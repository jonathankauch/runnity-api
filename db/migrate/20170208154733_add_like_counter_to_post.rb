class AddLikeCounterToPost < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :like, :integer, default: 0
  end
end
