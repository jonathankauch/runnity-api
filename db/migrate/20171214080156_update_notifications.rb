class UpdateNotifications < ActiveRecord::Migration[5.0]
  def self.up
    rename_column :notifications, :event_id, :target_id
    rename_column :notifications, :event_type, :target_type
    add_column :notifications, :applicant, :string
  end

  def self.down
    rename_column :notifications, :target_id, :event_id
    rename_column :notifications, :target_type, :event_type
    remove_column :notifications, :applicant
  end
end
