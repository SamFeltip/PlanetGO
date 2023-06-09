# frozen_string_literal: true

class AddAvailabilitiesToUsers < ActiveRecord::Migration[7.0]
  def change
    add_reference :availabilities, :user, foreign_key: { to_table: :users }
  end
end
