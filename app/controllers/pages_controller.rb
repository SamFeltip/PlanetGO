# frozen_string_literal: true

class PagesController < ApplicationController
  include CalendarHelper
  require './app/inputs/fake_select_input'

  def home; end
  before_action :authenticate_user!, only: %i[account]

  def landing; end

  def account
    @friends = current_user.following

    @future_outings = current_user.future_outings
    @past_outings = current_user.past_outings
    @liked_events = current_user.liked_events

    @calendar_start_date = Time.zone.at(342_000).to_date
    @availabilities = Availability.where(user_id: current_user.id)
    @availability = Availability.new
    @start_day_collection = { 'Monday' => 0, 'Tuesday' => 1, 'Wednesday' => 2, 'Thursday' => 3, 'Friday' => 4, 'Saturday' => 5, 'Sunday' => 6 }
    @end_day_collection = { 'Monday' => 0, 'Tuesday' => 1, 'Wednesday' => 2, 'Thursday' => 3, 'Friday' => 4, 'Saturday' => 5, 'Sunday' => 6, 'Mon-next' => 7 }
    @hour_collection = (0..23)
    @minute_collection = (0..59).step(15)
  end
end
