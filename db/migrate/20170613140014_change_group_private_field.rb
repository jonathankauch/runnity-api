class ChangeGroupPrivateField < ActiveRecord::Migration[5.0]
  def change
    rename_column :groups, :private, :private_status
  end
end
