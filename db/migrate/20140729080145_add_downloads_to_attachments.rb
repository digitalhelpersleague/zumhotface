class AddDownloadsToAttachments < ActiveRecord::Migration
  def change
    add_column :attachments, :downloads, :integer
  end
end
