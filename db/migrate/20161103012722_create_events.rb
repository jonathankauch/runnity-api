class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.string :name
      t.integer :owner
      t.text :description
      t.datetime :start_date
      t.datetime :end_date
      t.string :city
      t.boolean :private
      t.float :distance

      t.timestamps
    end
  end
end
