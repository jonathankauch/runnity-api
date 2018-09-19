class RemoveLongitudeLatitudeFromRun < ActiveRecord::Migration[5.0]
  def change
    remove_column :runs, :src_latitude
    remove_column :runs, :dest_latitude
    remove_column :runs, :src_longitude
    remove_column :runs, :dest_longitude
    remove_column :runs, :dest_name
    remove_column :runs, :name
    remove_column :runs, :owner
  end
end
