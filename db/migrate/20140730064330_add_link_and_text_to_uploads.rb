class AddLinkAndTextToUploads < ActiveRecord::Migration
  def change
    add_column :uploads, :link, :text
    add_column :uploads, :text, :text
  end
end
