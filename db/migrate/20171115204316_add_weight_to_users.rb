class AddWeightToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :weight, :integer, default: 60
  end
end
