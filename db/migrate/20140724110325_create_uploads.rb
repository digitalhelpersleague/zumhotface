class CreateUploads < ActiveRecord::Migration
  def change
    create_table :uploads do |t|
      t.string :sid, limit: 12, index: true

      t.timestamps
    end
  end
end
