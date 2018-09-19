class AddEventIdAndGroupIdToPost < ActiveRecord::Migration[5.0]
  def change
    add_reference :posts, :event, index: true, foreign_key: true
    add_reference :posts, :group, index: true, foreign_key: true
  end
end
