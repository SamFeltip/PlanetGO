# frozen_string_literal: true

class PagesController < ApplicationController
  def home; end
  before_action :authenticate_user!, only: %i[account]

  def landing; end

  def account
    # TODO: make this actually my friends
    @friends = current_user.friends

    @future_outings = current_user.future_outings
    @past_outings = current_user.past_outings
    @liked_events = current_user.liked_events
  end
end
