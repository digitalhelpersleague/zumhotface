collection :uploads
attributes :name, :sid, :upload_type, :encryption_type, :size, :created_at, :downloads, :url, :icon, :lang

node :is_secured do |upload|
  upload.secured?
end

node :is_encrypted do |upload|
  upload.encrypted?
end
