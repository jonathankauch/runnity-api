class ChangePrivateToPrivateStatusInEvent < ActiveRecord::Migration[5.0]
  def change
    rename_column :events, :private, :private_status
  end
end
