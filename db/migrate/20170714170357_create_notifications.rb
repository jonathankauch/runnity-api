class CreateNotifications < ActiveRecord::Migration[5.0]
  def change
    drop_table :notifications if ActiveRecord::Base.connection.table_exists? 'notifications'
    create_table :notifications do |t|
      t.references :event, polymorphic: true
      t.integer  :user_id
      t.string   :status
      t.timestamps
    end
  end
end
