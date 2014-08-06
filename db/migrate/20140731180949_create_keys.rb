class CreateKeys < ActiveRecord::Migration
  def change
    create_table :keys do |t|
      t.string :name
      t.integer :user_id
      t.string :type
      t.boolean :is_public, null: false, default: false
      t.integer :sibling_id
      t.text :body
      t.boolean :default, null: false, default: false

      t.timestamps
    end
    add_index :keys, :user_id
    add_index :keys, :type
    add_index :keys, :sibling_id
  end
end
