class AddFielsToRun < ActiveRecord::Migration[5.0]
  def change
    add_column :runs, :dest_name, :string
    add_column :runs, :started_at, :datetime
    add_column :runs, :src_latitude, :integer
    add_column :runs, :src_longitude, :integer
    add_column :runs, :dest_latitude, :integer
    add_column :runs, :dest_longitude, :integer
    add_column :runs, :total_distance, :integer
    add_column :runs, :total_time, :integer
    add_column :runs, :max_speed, :integer
  end
end
