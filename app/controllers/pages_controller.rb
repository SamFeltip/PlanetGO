class PagesController < ApplicationController

  def home
  end

  def landing
    @example = 'sam felton'
    # @special_reviews = ["review 1", "review 2", "review 3"]
    @special_reviews = Review.where(:is_on_landing_page => "true").order(:landing_page_position)
  end


  def go_up
    if current_user.admin?
      Review.find(params[:id]).go_up
      redirect_to "/#reviews"
    end
  end

  def go_down
    if current_user.admin?
      puts params
      Review.find(params[:id]).go_down
      redirect_to "/#reviews"

    end
  end

  def swap_columns(review1, review2)
    Review.swap_landing_page_positions(review1, review2)
  end

end