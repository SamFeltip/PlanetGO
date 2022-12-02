class PagesController < ApplicationController

  def home
  end

  def landing
    @example = 'sam felton'
    @special_reviews = Review.where(:is_on_landing_page => "true").order(:landing_page_position)
  end

  # shift the review up in the landing page
  def go_up
    if current_user.admin?
      Review.find(params[:id]).go_up
      redirect_to "/#reviews"
    end
  end

  #shift the review down in the landing page
  def go_down
    if current_user.admin?
      Review.find(params[:id]).go_down
      redirect_to "/#reviews"

    end
  end

  def swap_columns(review1, review2)
    Review.swap_landing_page_positions(review1, review2)
  end

end