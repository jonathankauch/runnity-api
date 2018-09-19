class AddFieldToGroup < ActiveRecord::Migration[5.0]
  def change
    add_column :groups, :private, :boolean
    add_column :groups, :owner, :integer
    add_column :groups, :name, :string
  end
end
