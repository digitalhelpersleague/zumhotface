class AddDownloadsToUploads < ActiveRecord::Migration
  def change
    add_column :uploads, :downloads, :integer, null: false, default: 0
  end
end
