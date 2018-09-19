class CreateAchievement < ActiveRecord::Migration[5.0]
  def change
    create_table :achievements do |t|
      t.string :content
      t.datetime :start_date
      t.datetime :due_date
      t.boolean :is_achieve, :default => false
    end
    add_reference :achievements, :user, index: true, foreign_key: true
  end
end
