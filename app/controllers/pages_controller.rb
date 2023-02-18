# frozen_string_literal: true

class PagesController < ApplicationController
  def home; end

  def landing
    @special_reviews = Review.where(is_on_landing_page: 'true').order(:landing_page_position)
  end
end
