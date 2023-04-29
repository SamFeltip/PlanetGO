# frozen_string_literal: true

class AddPostcodeToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :postcode, :string
    add_column :users, :latitude, :float
    add_index :users, :latitude
    add_column :users, :longitude, :float
    add_index :users, :longitude
  end
end
