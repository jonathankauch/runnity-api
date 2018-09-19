class AddPostIdAndCommentIdToPicture < ActiveRecord::Migration[5.0]
  def change
    add_reference :pictures, :post, index: true, foreign_key: true
    add_reference :pictures, :comment, index: true, foreign_key: true
  end
end
