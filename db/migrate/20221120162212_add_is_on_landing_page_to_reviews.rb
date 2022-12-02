class AddIsOnLandingPageToReviews < ActiveRecord::Migration[7.0]
  def change
    add_column :reviews, :is_on_landing_page, :boolean
  end
end
