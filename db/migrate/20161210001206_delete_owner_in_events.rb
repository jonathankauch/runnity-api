class DeleteOwnerInEvents < ActiveRecord::Migration[5.0]
  def change
    remove_column :events, :owner
  end
end
