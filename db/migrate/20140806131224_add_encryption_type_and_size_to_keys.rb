class AddEncryptionTypeAndSizeToKeys < ActiveRecord::Migration
  def change
    add_column :keys, :encryption_type, :string
    add_column :keys, :size, :integer
  end
end
