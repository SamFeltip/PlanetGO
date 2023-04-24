# frozen_string_literal: true

class AddAddressToEvent < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :address_line1, :string
    add_column :events, :address_line2, :string
    add_column :events, :town, :string
    add_column :events, :postcode, :string
    add_column :events, :latitude, :float
    add_index :events, :latitude
    add_column :events, :longitude, :float
    add_index :events, :longitude
  end
end
