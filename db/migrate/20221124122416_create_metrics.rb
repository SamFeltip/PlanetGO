# frozen_string_literal: true

class CreateMetrics < ActiveRecord::Migration[7.0]
  def change
    create_table :metrics do |t|
      t.datetime :time_enter
      t.datetime :time_exit
      t.string :route
      t.float :latitude
      t.float :longitude
      t.boolean :is_logged_in
      t.integer :number_interactions
      t.integer :pricing_selected

      t.timestamps
    end
  end
end
