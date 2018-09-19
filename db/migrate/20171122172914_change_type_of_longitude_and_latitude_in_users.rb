class ChangeTypeOfLongitudeAndLatitudeInUsers < ActiveRecord::Migration[5.0]
  def change
    change_column :users, :latitude, :decimal, :precision => 15, :scale => 13
    change_column :users, :longitude, :decimal, :precision => 15, :scale => 13
  end
end
