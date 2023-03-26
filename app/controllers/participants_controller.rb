# frozen_string_literal: true

class ParticipantsController < ApplicationController
  before_action :set_participant, only: %i[show edit update destroy]

  # GET /participants or /participants.json
  def index
    @participants = Participant.all
  end

  # GET /participants/1 or /participants/1.json
  def show; end

  # GET /participants/new
  def new
    @participant = Participant.new
  end

  # GET /participants/1/edit
  def edit; end

  # POST /participants or /participants.json
  def create
    # participant_params["user_id"] = current_user.id
    # participant_params["outing_id"] = Outing.first.id

    @participant = Participant.new(participant_params)

    # @participant.user = current_user
    # @participant.outing = Outing.first

    respond_to do |format|
      if @participant.save
        format.html { redirect_to participant_url(@participant), notice: t('.notice') }
        format.json { render :show, status: :created, location: @participant }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @participant.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /participants/1 or /participants/1.json
  def update
    respond_to do |format|
      if @participant.update(participant_params)
        format.html { redirect_to participant_url(@participant), notice: t('.notice') }
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

    respond_to do |format|
      format.html { redirect_to set_details_outing_path(@outing), notice: t('.notice') }
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
