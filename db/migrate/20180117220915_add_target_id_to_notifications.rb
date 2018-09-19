class AddTargetIdToNotifications < ActiveRecord::Migration[5.0]
  def self.up
    add_column :notifications, :request_id, :integer
  end

  def self.down
    remove_column :notifications, :request_id, :integer
  end
end
