class Upload < ActiveRecord::Base

  SAFE_CHARS = (('A'..'Z').to_a + ('a'..'z').to_a + ('0'..'9').to_a + %w(- _ ~)).freeze

  belongs_to :user

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

  before_validation :set_unique_identifier

  after_commit :analyze_language, on: :create

  #after_create :move_to_s3

  #TODO: encrypt with AES128/256
  #def encrypt(passphrase)
  #end
  #
  #TODO: compress links and texts with gzip

  %w(file link code).each do |type|
    define_method("#{type}?"){ self.class.to_s == "Upload::#{type.camelize}" }
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
    return file.size if file?
    return text.bytesize if code?
    return link.bytesize if link?
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
    if file.try(:path) && !encrypted?
      resque = Resque.enqueue(Jobs::LanguageDetector, sid)
    end
  end

private
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
