# frozen_string_literal: true

class AddCategoryToEvent < ActiveRecord::Migration[7.0]
  def change
    add_reference :events, :category, index: true
    add_foreign_key :events, :categories
  end
end
