class AddDigestToUploads < ActiveRecord::Migration
  def change
    add_column :uploads, :digest, :string
  end
end
