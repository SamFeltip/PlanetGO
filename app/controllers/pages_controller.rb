class PagesController < ApplicationController

  def home
  end

  def landing
    @example = 'sam felton'
    # @special_reviews = ["review 1", "review 2", "review 3"]
    @special_reviews = Review.where(:is_on_landing_page => "true")
  end

end