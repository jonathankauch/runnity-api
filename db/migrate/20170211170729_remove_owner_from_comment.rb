class RemoveOwnerFromComment < ActiveRecord::Migration[5.0]
  def change
    remove_column :comments, :owner
  end
end
