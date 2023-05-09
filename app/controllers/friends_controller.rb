# frozen_string_literal: true

class FriendsController < ApplicationController
  before_action :set_user, only: %i[follow unfollow accept decline cancel]
  authorize_resource class: false

  def index
    @friends = current_user.following.page(params[:page])
  end

  # GET /friends/search
  def search
    return unless params[:search].present? && params[:search][:name].present?

    @name = params[:search][:name]
    @users = User.by_full_name(@name).exclude_current_user(current_user.id).page(params[:page])
  end

  # GET /friends/requests
  def requests
    @requests = current_user.follow_requests
  end

  # POST friends/:id/follow
  def follow
    current_user.send_follow_request_to(@user)

    redirect_to friend_search_path
  end

  # POST friends/:id/unfollow
  def unfollow
    current_user.unfollow(@user)
    @user.unfollow(current_user)

    redirect_to friends_path
  end

  # POST friends/:id/accept
  def accept
    current_user.accept_follow_request_of(@user)
    current_user.send_follow_request_to(@user)
    @user.accept_follow_request_of(current_user)

    redirect_to friend_requests_path
  end

  # POST friends/:id/decline
  def decline
    current_user.decline_follow_request_of(@user)

    redirect_to friend_requests_path
  end

  # POST friends/:id/cancel
  def cancel
    current_user.remove_follow_request_for(@user)

    redirect_to friend_search_path
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
