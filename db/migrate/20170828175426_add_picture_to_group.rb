class AddPictureToGroup < ActiveRecord::Migration[5.0]
  def change
    add_reference :pictures, :group, index: true, foreign_key: true
  end
end
