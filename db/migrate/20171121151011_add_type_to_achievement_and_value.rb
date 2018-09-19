class AddTypeToAchievementAndValue < ActiveRecord::Migration[5.0]
  def change
    add_column :achievements, :achievement_type, :string
    add_column :achievements, :value, :integer
  end
end
