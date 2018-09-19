class AddInformationToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :firstname, :string
    add_column :users, :lastname, :string
    add_column :users, :phone, :string
    add_column :users, :address, :text
    add_column :users, :enable, :boolean
  end
end
