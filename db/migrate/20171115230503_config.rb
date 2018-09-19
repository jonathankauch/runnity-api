class Config < ActiveRecord::Migration[5.0]
  def self.up
    add_column :configs, :group_id, :integer
  end

  def self.down
    remove_column :configs, :group_id
  end
end
