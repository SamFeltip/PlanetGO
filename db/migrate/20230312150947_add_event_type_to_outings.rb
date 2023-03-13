class AddEventTypeToOutings < ActiveRecord::Migration[7.0]
  def change
    add_column :outings, :event_type, :integer
    add_column :outings, :invitation_token, :bigint
  end
end
