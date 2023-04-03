# frozen_string_literal: true

class CreateCategoryInterests < ActiveRecord::Migration[7.0]
  def change
    create_table :category_interests, &:timestamps
  end
end
