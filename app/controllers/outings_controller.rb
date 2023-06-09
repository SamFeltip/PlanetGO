# frozen_string_literal: true

class OutingsController < ApplicationController
  include OutingsHelper
  before_action :authenticate_user!
  before_action :set_outing, only: %i[show edit update destroy set_details send_invites stop_count]
  before_action :set_participant, only: %i[show set_details]
  before_action :set_availabilities, only: %i[send_invites set_details]
  load_and_authorize_resource

  # GET /outings or /outings.json
  def index
    @outings_past = current_user.past_outings
    @outings_future = current_user.future_outings
  end

  # GET /outings/1 or /outings/1.json
  def show
    authorize! :show, @outing
    @participants = @outing.participants
  end

  # GET /outings/new
  def new
    @outing = Outing.new
  end

  # GET /outings/1/edit
  def edit
    authorize! :edit, @outing
  end

  # POST /outings or /outings.json
  def create
    @outing = Outing.new(outing_params)

    @outing.invite_token = @outing.id.to_s + rand(100_000).to_s

    @participant = @outing.participants.build(
      user_id: current_user.id,
      status: Participant.statuses[:creator]
    )

    @outing.creator_id = current_user.id

    respond_to do |format|
      if @outing.save

        format.html { redirect_to outing_path(@outing), notice: 'Outing was successfully created.' }
        format.json { render :show, status: :created, location: @outing }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @outing.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /outings/1 or /outings/1.json
  def update
    authorize! :update, @outing
    respond_to do |format|
      if @outing.update(outing_params) && outing_params.key?('date')
        format.json { render json: { status: :updated, start_date: outing_params['date'] } }
      elsif @outing.update(outing_params)
        format.html { redirect_to outing_url(@outing) }
        format.json { render :show, status: :ok, location: @outing }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @outing.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /outings/1 or /outings/1.json
  def destroy
    authorize! :destroy, @outing
    @outing.destroy

    respond_to do |format|
      format.html { redirect_to outings_url, notice: 'Outing was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /outings/1/set_details
  def set_details
    authorize! :set_details, @outing
    @calendar_start_date, @peoples_availabilities, @good_start_datetime = remake_calendar(@outing)

    @proposed_event = ProposedEvent.new

    @positions = %w[who when where]

    @final_events = current_user.final_events
  end

  def send_invites
    authorize! :send_invites, @outing
    @friend_ids = params[:user_ids]
    @participants = Participant.none

    @friend_ids = [] if @friend_ids.nil?

    @friend_ids.each do |friend_id|
      # create a participant and add it to the @participants list
      new_participant = Participant.create(user_id: friend_id, outing_id: @outing.id)
      @participants = @participants.or(Participant.where(id: new_participant.id))
    end

    # Creates a new calendar object using the new participants list
    @calendar_start_date, @peoples_availabilities, @good_start_datetime = remake_calendar(@outing)

    respond_to do |format|
      format.html { redirect_to set_details_outing_path(@outing) }
      format.js
    end
  end

  def stop_count
    authorize! :stop_count, @outing
    @failed_proposed_events = ProposedEvent.where(outing_id: @outing.id).failed_vote.each(&:destroy)

    respond_to do |format|
      format.js
      format.html { redirect_to outing_path(@outing), notice: 'failed proposed events were deleted.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_outing
    @outing = Outing.includes(proposed_events: { event: :category }).find_by(invite_token: params[:invite_token])
  end

  def set_participant
    # for proposed event cards
    @participant = @outing.participants.find_by(user: current_user)
  end

  def set_availabilities
    @peoples_availabilities = []
    @outing.participants.each do |participant|
      @peoples_availabilities.append(Availability.where(user_id: participant.user_id))
    end
  end

  # Only allow a list of trusted parameters through.
  def outing_params
    params.require(:outing).permit(:name, :date, :description, :outing_type, :invite_token)
  end
end
