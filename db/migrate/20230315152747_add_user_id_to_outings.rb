# frozen_string_literal: true

class AddUserIdToOutings < ActiveRecord::Migration[7.0]
  def change
    add_reference :outings, :creator, foreign_key: { to_table: :users }
  end
end
