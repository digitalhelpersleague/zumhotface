class Key < ActiveRecord::Base
  PASSPHRASE_SAFE_CHARS = (('0'..'9').to_a + ('a'..'z').to_a + ('A'..'Z').to_a + %w(_@!,.:;^~_)).freeze
  ENCRYPTION_TYPES = ['xyu']
  # SIZE=[]
  # DEFAULT_ENCRYPTION_TYPE = ""
  # DEFAULT_SIZE = 0

  belongs_to :user
  belongs_to :sibling, class_name: 'Key'

  # validates_presence_of :user_id
  # validates_length_of :name, in: 2..255, allow_blank: false
  # validates_uniqueness_of :name, scope: [:user_id]
  # validates_presence_of :body
  # validates_presence_of :numbits
  ## validates_format_of :passphrase, with: /[]/
  # validates_length_of :passphrase, minimum: 4, maximum: 255

  validates_presence_of :encryption_type
  validates_inclusion_of :encryption_type, in: proc { puts self; self.class::ENCRYPTION_TYPES }

  # TODO: Google for STI constants and validations

  # validate passphrase by regex [a-zA-Z0-9]
  # validates_uniqueness_of name

  # def self.whoami
  # Proc.new{ puts self }
  # end

  def self.provider
    ''
  end

  # def prepare_options
  # self.encryption_type = self.class::DEFAULT_ENCRYPTION_TYPE unless self.class::ENCRYPTION_TYPES.include?(self.encryption_type)
  # self.numbits = self.class::DEFAULT_SIZE unless self.class::SIZE.include?(self.numbits)
  # self.passphrase = "1234" unless self.passphrase
  # end
end
