class RemoveinvitationTokenFromOuting < ActiveRecord::Migration[7.0]
  def change
    remove_column :outings, :invitation_token
  end
end
