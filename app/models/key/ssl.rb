class Key::SSL < Key

  ENCRYPTION_TYPES = %w(aes256 aes128)
  SIZE = 1024..4096
  DEFAULT_ENCRYPTION_TYPE = "aes256"
  DEFAULT_SIZE = 2048

  def self.provider
    "OpenSSL"
  end

  def generate_key
    puts "openssl genrsa -#{encryption_type} -passout pass:#{passphrase} #{numbits}"
    self.body = `openssl genrsa -#{encryption_type} -passout pass:#{passphrase} #{numbits}`
  end

end
