class AddTypeAndEncryptionTypeToUploads < ActiveRecord::Migration
  def change
    add_column :uploads, :type, :string
    add_column :uploads, :encryption_type, :string
  end
end
