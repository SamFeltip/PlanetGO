# frozen_string_literal: true

class RegisterInterestsController < ApplicationController
  before_action :set_register_interest, only: %i[edit destroy]
  before_action :authenticate_user!, only: %i[index edit destroy]
  load_and_authorize_resource

  # GET /register_interests or /register_interests.json
  def index
    @register_interests = RegisterInterest.all
  end

  # GET /register_interests/new
  def new
    @register_interest = RegisterInterest.new
    @pricing_id = params[:pricing_id]
  end

  # GET /register_interests/1/edit
  def edit; end

  # POST /register_interests or /register_interests.json
  def create
    @register_interest = RegisterInterest.new(register_interest_params)
    @pricing_id = params[:pricing_id]
    @register_interest.pricing_id = @pricing_id
    @registered_email = register_interest_params[:email]
    respond_to do |format|
      if @register_interest.save
        # This could be better
        format.html do
          redirect_to "/users/sign_up?email=#{@registered_email}",
                      notice: 'Your interest has been recorded, and you will be contacted when we are ready for new users.'
        end
        format.json { render :show, status: :created, location: @register_interest }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @register_interest.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /register_interests/1 or /register_interests/1.json
  def destroy
    @register_interest.destroy

    respond_to do |format|
      format.html do
        redirect_to pricing_register_interests_path(@register_interest.pricing_id),
                    notice: 'Register interest was successfully destroyed.'
      end
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_register_interest
    @register_interest = RegisterInterest.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def register_interest_params
    params.require(:register_interest).permit(:email, :pricing_id)
  end
end
