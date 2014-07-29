class AddTypeAndEncryptionTypeToUploads < ActiveRecord::Migration
  def change
    add_column :uploads, :type, :string
    add_column :uploads, :encryption_type, :string
    add_index :uploads, :type
  end
end
