# frozen_string_literal: true

class AddClicksToReviews < ActiveRecord::Migration[7.0]
  def change
    add_column :reviews, :clicks, :integer, default: 0
  end
end
