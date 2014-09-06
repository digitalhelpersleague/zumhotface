class Upload < ActiveRecord::Base

  SAFE_CHARS = (('A'..'Z').to_a + ('a'..'z').to_a + ('0'..'9').to_a + %w(- _ ~)).freeze

  belongs_to :user

  before_destroy :decrement_total_weight

  has_attached_file :file,
    hash_secret: Settings.uploads.secret_key,
    hash_data: "uploads/file/:id/:style/:updated_at",
    url: "/system/uploads/:id_partition/:hash.:extension",
    path: ":rails_root/public/system/uploads/:id_partition/:hash.:extension"

    #TODO: move to s3
      #path: "/uploads/:id_partition/:hash.:extension",
      #url: ":s3_domain_url",
      #storage: :s3,
      #s3_credentials: Settings.uploads.aws_s3.s3_credentials,
      #bucket: Settings.uploads.aws_s3.bucket

  # skip content type validation
  validates_attachment_content_type :file, content_type: /.*/

  validate :must_have_free_storage_space

  before_validation :get_proper_type
  before_validation :set_unique_identifier

  after_commit :analyze_language, on: :create
  after_commit :increment_total_weight, on: :create

  #after_create :move_to_s3

  #TODO: encrypt with AES128/256
  #def encrypt(passphrase)
  #end
  #
  #TODO: compress links and code with gzip

  %w(file link code).each do |type|
    define_method("#{type}?"){ self.type == "Upload::#{type.camelize}" }
  end
  
  def self.upload_type
    nil
  end

  def image?
    file? && file.content_type.include?("image")
  end

  def secured?
    !!password
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

  def validate_access with_password: nil
    return with_password.to_s == password if secured?
    true
  end

  #def encrypt
  #end

  def download!
    self.downloads += 1
    save
  end

  def analyze_language
    if !!file.try(:path) && !encrypted?
      resque = Resque.enqueue(Jobs::LanguageDetector, sid)
    end
  end

  def must_have_free_storage_space
    errors.add(:file, "no space left") if size.to_i > user.storage.free
  end

private

  def get_proper_type
    self.type ||= 'Upload::Code' if !!code
    self.type ||= 'Upload::Link' if !!link
    self.type ||= 'Upload::File' if !!file
  end

  def increment_total_weight
    user.update_total_weight(size)
  end

  def decrement_total_weight
    user.update_total_weight(-size)
  end

  def set_unique_identifier
    unless self.sid
      begin
          self.sid = generate_identifier
      end while self.class.exists?(sid: self.sid)
    end
  end

  def generate_identifier
    # limit to 75418890625 unique combinations
    # so we should increase chars count later
    Array.new(6){ SAFE_CHARS.sample }.join
  end

end
