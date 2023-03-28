class AddInviteTokenToOuting < ActiveRecord::Migration[7.0]
  def change
    add_column :outings, :invite_token, :string
    add_index :outings, :invite_token, unique: true
  end
end
