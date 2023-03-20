# frozen_string_literal: true

class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.string :name
      t.datetime :time_of_event
      t.text :description
      t.integer :category
      t.boolean :approved

      t.references :user, null: false, foreign_key: true # owner of the event

      t.timestamps
    end
  end
end
