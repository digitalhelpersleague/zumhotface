object :upload
attributes :sid, :is_encrypted, :is_secured, :url, :name, :upload_type, :size, :created_at, :downloads, :icon, :lang

node :is_secured do |upload|
  upload.secured?
end

node :is_encrypted do |upload|
  upload.encrypted?
end
