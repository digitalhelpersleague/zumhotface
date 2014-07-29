class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments, id: false do |t|
      t.string :sid, limit: 12, primary: true
      t.timestamps
    end
  end
end
