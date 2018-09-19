class AddCaloriesToRun < ActiveRecord::Migration[5.0]
  def change
    add_column :runs, :calories, :float, default: 0.0

    Run.update_all calories: (rand 300.0..1500.0).round(2)
  end
end
