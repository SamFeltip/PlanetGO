# frozen_string_literal: true

class PagesController < ApplicationController
  def home; end

  def landing
    @special_reviews = Review.where(is_on_landing_page: 'true').order(:landing_page_position)
  end

  def account

    @future_outings = Outing.future_outings(current_user)
    @past_outings = Outing.past_outings(current_user)
  end
end
