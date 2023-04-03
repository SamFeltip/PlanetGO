# frozen_string_literal: true

class CategoryInterestsController < ApplicationController
  before_action :set_category_interest, only: %i[set_interest]
  before_action :authenticate_user!, only: %i[index set_interest]
  load_and_authorize_resource

  # GET /category_interests or /category_interests.json
  def index
    @category_interests = CategoryInterest.where(user_id: current_user.id).sort
  end

  def set_interest
    @category_interest = CategoryInterest.find(params[:id])
    interest_setting = params[:interest]
    return unless @category_interest.interest != interest_setting # Don't update if nothing changing
    return unless interest_setting.to_i <= 1 || interest_setting.to_i >= -1 # Only allow within a range

    respond_to do |format|
      if @category_interest.update(interest: interest_setting)
        format.html { redirect_to category_interests_url, notice: 'Category interest was successfully updated.' }
        format.json { render :show, status: :ok, location: @category_interest }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @category_interest.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_category_interest
    @category_interest = CategoryInterest.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def category_interest_params
    params.require(:category_interest).permit(:category_id, :user_id, :interest)
  end
end
