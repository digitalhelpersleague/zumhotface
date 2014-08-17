class Key::GPG < Key

  ENCRYPTION_TYPES = %w(AES AES192 AES256 CAMELLIA128 CAMELLIA192 CAMELLIA256)
  SIZE = 1024..4096
  DEFAULT_ENCRYPTION_TYPE = "AES256"
  DEFAULT_SIZE = 2048

  def self.provider
    "GPG"
  end

  def generate_key
    pubkey RSA
    Cipher AES
    puts "gpg -q --gen-key -#{encryption_type} -passout pass:#{passphrase} #{numbits}"
    --passphrase
  end


end
