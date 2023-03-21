# frozen_string_literal: true

class AddChangeEventTypeName < ActiveRecord::Migration[7.0]
  def change
    change_table :outings, bulk: true do |t|
      t.add_column :outing_type, :integer
      t.remove_column :event_type, :integer
    end
  end
end
