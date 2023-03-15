# frozen_string_literal: true

class PagesController < ApplicationController
  def home; end
  before_action :authenticate_user!, only: %i[account]

  def landing

  end

  def account
    # TODO make this actually my friends
    @friends = User.where("id < 5")

    @future_outings = current_user.future_outings
    @past_outings = current_user.past_outings
  end
end
