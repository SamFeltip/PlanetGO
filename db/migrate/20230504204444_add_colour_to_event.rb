# frozen_string_literal: true

class AddColourToEvent < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :colour, :integer
  end
end
