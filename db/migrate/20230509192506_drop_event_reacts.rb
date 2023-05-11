# frozen_string_literal: true

class DropEventReacts < ActiveRecord::Migration[7.0]
  def change
    drop_table :event_reacts do |t|
      t.references :event, null: false, foreign_key: true
      t.references :outing, null: false, foreign_key: true

      t.timestamps
    end
  end
end
