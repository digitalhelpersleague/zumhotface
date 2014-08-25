class AddStorageToUsers < ActiveRecord::Migration
  def change
    add_column :users, :storage, :integer
  end
end
