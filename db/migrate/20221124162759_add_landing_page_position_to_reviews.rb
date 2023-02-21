# frozen_string_literal: true

class AddLandingPagePositionToReviews < ActiveRecord::Migration[7.0]
  def change
    add_column :reviews, :landing_page_position, :integer
  end
end
