class AddUserIdToUploads < ActiveRecord::Migration
  def change
    add_column :uploads, :user_id, :integer
    add_index :uploads, :user_id
  end
end
