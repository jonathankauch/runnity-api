class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.integer :owner
      t.integer :post_id
      t.text :content
      t.string :picture

      t.timestamps
    end
  end
end
