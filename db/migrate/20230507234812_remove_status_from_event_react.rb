# frozen_string_literal: true

class RemoveStatusFromEventReact < ActiveRecord::Migration[7.0]
  def change
    remove_column :event_reacts, :status, :integer
  end
end
