class AddPasswordToUploads < ActiveRecord::Migration
  def change
    add_column :uploads, :password, :string
  end
end
