# frozen_string_literal: true

class AddEventTypeToOutings < ActiveRecord::Migration[7.0]
  def change
    change_table :outings, bulk: true do |t|
      t.add_column :event_type, :integer
      t.add_column :invitation_token, :bigint
    end
  end
end
