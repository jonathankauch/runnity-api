class AddConfigIdToGroup < ActiveRecord::Migration[5.0]
  def self.up
    add_column :groups, :config_id, :integer
  end

  def self.down
    remove_column :groups, :config_id
  end
end
