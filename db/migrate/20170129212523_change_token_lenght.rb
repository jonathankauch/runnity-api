class ChangeTokenLenght < ActiveRecord::Migration[5.0]
  def change
    change_column :users, :authentication_token, :string, limit: 40
  end
end
