class CreateGpgKeys < ActiveRecord::Migration
  def change
    create_table :gpg_keys do |t|
      t.integer :user_id
      t.integer :key_type
      t.text :body
      t.boolean :default

      t.timestamps
    end
    add_index :gpg_keys, :user_id
    add_index :gpg_keys, :key_type
  end
end
