class AverageSpeedOnUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :average_speed, :float, default: 8
  end
end
