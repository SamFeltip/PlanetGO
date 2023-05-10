# frozen_string_literal: true

class ParticipantsController < ApplicationController
  include OutingsHelper
  before_action :set_participant, only: %i[show edit update destroy]

  # GET /participants or /participants.json
  def index
    @participants = Participant.all
  end

  # GET /participants/1 or /participants/1.json
  def show; end

  # GET /participants/new
  def new
    if current_user
      create
    else
      redirect_to new_user_registration_path(invite_token: params[:invite_token])
    end
  end

  # GET /participants/1/edit
  def edit; end

  # POST /participants or /participants.json
  def create
    outing = Outing.find_by(invite_token: params[:invite_token])
    Participant.where(outing_id: outing, user_id: current_user).first_or_create
    redirect_to outings_path
  end

  def invite
    @participant = Participant.new(participant_params)
  end

  # PATCH/PUT /participants/1 or /participants/1.json
  def update
    respond_to do |format|
      if @participant.update(participant_params)
        format.html { redirect_to participant_url(@participant) }
        format.json { render :show, status: :ok, location: @participant }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @participant.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /participants/1 or /participants/1.json
  def destroy
    @user = @participant.user
    @outing = @participant.outing

    unless @participant.destroy
      flash[:error] = t('.error')
      redirect_to @user
      return
    end

    # Creates a new calendar object using the new participants list
    @calendar_start_date, @peoples_availabilities, @good_start_datetime = remake_calendar(@outing)

    respond_to do |format|
      format.html { redirect_to set_details_outing_path(@outing) }
      format.js
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_participant
    @participant = Participant.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def participant_params
    params.require(:participant).permit(:status, :user_id, :outing_id)
  end
end
