class Attachment < ActiveRecord::Base

  belongs_to :user

  has_attached_file :file,
      hash_secret: Settings.attachments.secret_key,
      path: "/attachments/:id_partition/:hash.:extension",
      url: ":s3_domain_url",
      storage: :s3,
      s3_credentials: Settings.attachments.aws_s3.s3_credentials,
      bucket: Settings.attachments.aws_s3.bucket

  #TODO: skip content type validation
  # validates_attachment_content_type :attachment, content_type: %w(image/jpeg image/jpg image/png)

end
