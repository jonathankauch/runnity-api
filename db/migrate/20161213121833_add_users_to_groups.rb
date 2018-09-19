class AddUsersToGroups < ActiveRecord::Migration[5.0]
  def change
    add_reference :groups, :user, index: true, foreign_key: true
    remove_column :groups, :owner
  end
end
