class AddTypeAndEncryptionTypeToAttachments < ActiveRecord::Migration
  def change
    add_column :attachments, :type, :string
    add_column :attachments, :encryption_type, :string
  end
end
