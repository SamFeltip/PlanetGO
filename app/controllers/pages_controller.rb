class PagesController < ApplicationController

  def home
  end

  def landing
    @example = 'sam felton'
    @special_reviews = ["review 1", "review 2", "review 3"]
  end

end