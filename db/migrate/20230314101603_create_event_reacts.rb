# frozen_string_literal: true

class CreateEventReacts < ActiveRecord::Migration[7.0]
  def change
    create_table :event_reacts do |t|
      t.references :user, null: false, foreign_key: true
      t.references :event, null: false, foreign_key: true
      t.integer :status, null: false, default: 0

      t.timestamps
    end
  end
end
