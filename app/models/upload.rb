class Upload < ActiveRecord::Base
  SAFE_CHARS = (('A'..'Z').to_a + ('a'..'z').to_a + ('0'..'9').to_a + %w(- _ ~)).freeze

  belongs_to :user

  before_destroy :decrement_total_weight

  before_validation on: :create do
    if file_content_type == 'application/octet-stream'
      mime_type = MIME::Types.type_for(file_file_name)
      self.file_content_type = mime_type.first.content_type if mime_type.first
    end
  end

  has_attached_file :file,
    hash_secret: Settings.uploads.secret_key,
    hash_data: 'uploads/file/:id/:style/:updated_at',
    url: '/system/uploads/:id_partition/:hash.:extension',
    path: ':rails_root/public/system/uploads/:id_partition/:hash.:extension',
    styles: {
      icon: "64x64^",
      thumb: "150x150^" },
    convert_options: {
      icon: "-gravity center -extent 64x64",
      thumb: "-gravity center -extent 150x150" }

  process_in_background :file

  before_post_process :skip_for_non_image

  def skip_for_non_image
    image?
  end

  # TODO: move to s3
  # path: "/uploads/:id_partition/:hash.:extension",
  # url: ":s3_domain_url",
  # storage: :s3,
  # s3_credentials: Settings.uploads.aws_s3.s3_credentials,
  # bucket: Settings.uploads.aws_s3.bucket

  # skip content type validation
  validates_attachment_content_type :file, content_type: /.*/

  validates :sid, presence: true, uniqueness: true
  validates :user_id, presence: true
  validate :must_have_free_storage_space

  before_validation :set_proper_type!
  before_validation :set_unique_identifier!

  after_commit :analyze_language, on: :create
  after_commit :increment_total_weight, on: :create

  # after_create :move_to_s3

  # TODO: compress links and code with gzip

  %w(blob link code).each do |type|
    define_method("#{type}?") { self.type == "Upload::#{type.camelize}" }
  end

  def self.upload_type
    nil
  end

  def image?
    file? && file.content_type.include?('image')
  end

  def secured?
    password.present?
  end

  def encrypted?
    false
  end

  def size
    size = if code?
             code.bytesize
           elsif link?
             link.bytesize
           else
             file_file_size
           end
    size.to_i
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

  def analyze_language
    Resque.enqueue(Jobs::LanguageDetector, sid) if file.try(:path) && !encrypted?
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
