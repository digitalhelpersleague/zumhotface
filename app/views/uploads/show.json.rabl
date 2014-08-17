object :upload
attributes :sid, :is_encrypted, :is_secured, :url

node :is_secured do |upload|
  upload.secured?
end

node :is_encrypted do |upload|
  upload.encrypted?
end
