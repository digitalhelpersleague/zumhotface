class RenameTextToCodeForUploads < ActiveRecord::Migration
  def change
    rename_column :uploads, :text, :code
  end
end
