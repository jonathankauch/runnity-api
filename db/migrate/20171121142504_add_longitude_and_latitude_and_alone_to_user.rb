class AddLongitudeAndLatitudeAndAloneToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :longitude, :integer
    add_column :users, :latitude, :integer
    add_column :users, :alone, :boolean
  end
end
