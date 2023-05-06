# frozen_string_literal: true

class SessionsController < Devise::SessionsController
  def new
    @outing = Outing.find_by(invite_token: params[:invite_token]) if params[:invite_token]
    super
  end

  def create
    outing = Outing.find_by(invite_token: params[:user][:invite_token])
    Participant.where(outing:, user: current_user).first_or_create if outing
    super
  end
end
