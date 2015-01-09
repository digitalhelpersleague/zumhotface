class Upload < ActiveRecord::Base
  SAFE_CHARS = (('A'..'Z').to_a + ('a'..'z').to_a + ('0'..'9').to_a + %w(- _ ~)).freeze

  before_validation :set_proper_type!
  before_validation :set_unique_identifier!

  include HasAttachment
  include Encryptable

  # FIXME: after_commit on destroy
  before_destroy :decrement_total_weight

  belongs_to :user

  validates :sid, presence: true
  validates :user_id, presence: true
  validate :must_have_free_storage_space

  after_commit :increment_total_weight, on: :create

  # TODO: compress links and code with gzip

  %w(blob link code).each do |type|
    define_method("#{type}?") { self.type == "Upload::#{type.camelize}" }
  end

  def secured?
    password.present?
  end

  def size
    nil
  end

  def raw_viewable?
    code? || lang
  end

  def validate_access(with_password: nil)
    !secured? || with_password.to_s == password
  end

  def download!
    self.downloads += 1
    save
  end

  def must_have_free_storage_space
    errors.add(:file, 'no space left') if size.to_i > user.storage.free
  end

  private

  def set_proper_type!
    if code
      self.becomes!(Code)
    elsif link
      self.becomes!(Link)
    elsif file
      self.becomes!(Blob)
    end
  end

  def increment_total_weight
    user.update_total_weight(size)
  end

  def decrement_total_weight
    user.update_total_weight(-size)
  end

  def set_unique_identifier!
    return if sid
    loop do
      self.sid = generate_identifier
      break unless self.class.exists?(sid: sid)
    end
  end

  def generate_identifier
    # limit to 75418890625 unique combinations
    # so we should increase chars count later
    Array.new(6) { SAFE_CHARS.sample }.join
  end
end
