class CreateConfigs < ActiveRecord::Migration[5.0]
  def change
    create_table :configs do |t|
      t.boolean :is_invitable, :default => true
      t.boolean :is_commentable, :default => true
      t.timestamps
    end
  end
end
