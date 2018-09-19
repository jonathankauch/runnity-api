class AddTargetToMemberRequest < ActiveRecord::Migration[5.0]
  def change
    add_column :member_requests, :target, :string
  end
end
