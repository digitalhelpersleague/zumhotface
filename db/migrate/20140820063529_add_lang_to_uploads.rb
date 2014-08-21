class AddLangToUploads < ActiveRecord::Migration
  def change
    add_column :uploads, :lang, :string
  end
end
