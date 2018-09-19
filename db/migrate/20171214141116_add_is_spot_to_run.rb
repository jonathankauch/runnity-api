class AddIsSpotToRun < ActiveRecord::Migration[5.0]
  def change
    add_column :runs, :is_spot, :boolean, default: false
  end
end
