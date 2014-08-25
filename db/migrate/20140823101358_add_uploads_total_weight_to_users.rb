class AddUploadsTotalWeightToUsers < ActiveRecord::Migration
  def change
    add_column :users, :uploads_total_weight, :integer, null: false, default: 0
  end
end
