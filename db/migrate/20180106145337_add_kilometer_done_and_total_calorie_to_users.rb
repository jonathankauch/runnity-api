class AddKilometerDoneAndTotalCalorieToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :kilometer_done, :integer
    add_column :users, :total_calorie, :integer
  end
end
