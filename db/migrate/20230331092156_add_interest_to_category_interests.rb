# frozen_string_literal: true

class AddInterestToCategoryInterests < ActiveRecord::Migration[7.0]
  def change
    add_column :category_interests, :interest, :integer, null: false, default: 0
  end
end
