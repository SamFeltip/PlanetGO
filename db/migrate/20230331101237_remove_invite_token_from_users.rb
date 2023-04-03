class RemoveInviteTokenFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :invite_token, :string
  end
end
