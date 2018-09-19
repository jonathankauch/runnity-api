class CreateMemberRequests < ActiveRecord::Migration[5.0]
  def change
    create_table :member_requests do |t|
      t.references :requests, polymorphic: true
      t.integer  :user_id
      t.string   :status
      t.integer   :role
      t.timestamps
    end
  end
end
