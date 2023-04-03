# frozen_string_literal: true

class AddCategoryAndUserToCategoryInterest < ActiveRecord::Migration[7.0]
  def change
    add_reference :category_interests, :category, index: true, foreign_key: true, null: false
    add_reference :category_interests, :user, index: true, foreign_key: true, null: false
  end
end
