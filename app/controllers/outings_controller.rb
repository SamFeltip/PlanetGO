# frozen_string_literal: true

class OutingsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  before_action :set_outing, only: %i[show edit update destroy set_details send_invites stop_count]
  before_action :set_participant, only: %i[show set_details]

  # GET /outings or /outings.json
  def index
    @outings = Outing.all.order_soonest
    return if current_user.admin?

    @outings = Outing.joins(:participants).where('participants.user_id' => current_user.id).order_soonest
  end

  # GET /outings/1 or /outings/1.json
  def show
    @participants = @outing.participants
    # @participants = Participant.find_by(outing_id: params[:outing_id])
  end

  # GET /outings/new
  def new
    @outing = Outing.new
  end

  # GET /outings/1/edit
  def edit; end

  # GET /outings/1/set_details
  def set_details
    @calendar_start_date = Time.zone.at(342_000).to_date
    participants = Participant.where(outing_id: @outing.id)
    @peoples_availabilities = []
    participants.each do |participant|
      @peoples_availabilities.append(Availability.where(user_id: participant.user_id))
    end

    @proposed_event = ProposedEvent.new

    @positions = %w[who when where]


    if current_user.postcode?
      random_hotel = current_user.local_events.joins(:category).where(category: { name: 'accommodation' }).sample
      random_restaurant = current_user.local_events.joins(:category).where(category: { name: 'restaurant' }).sample
    else
      random_hotel = Event.joins(:category).where(category: { name: 'accommodation' }).sample
      random_restaurant = Event.joins(:category).where(category: { name: 'restaurant' }).sample
    end

    final_event_ids = []


    final_event_ids << random_hotel.id unless random_hotel.nil?
    final_event_ids << random_restaurant.id unless random_restaurant.nil?
    @final_events = Event.find(final_event_ids)

  end

  def send_invites
    @friend_ids = params[:user_ids]
    @participants = Participant.none

    @friend_ids = [] if @friend_ids.nil?

    @friend_ids.each do |friend_id|
      # create a participant and add it to the @participants list
      new_participant = Participant.create(user_id: friend_id, outing_id: @outing.id)
      @participants = @participants.or(Participant.where(id: new_participant.id))
    end

    # Creates a new calendar object using the new participants list
    @calendar_start_date = Time.zone.at(342_000).to_date
    participants = Participant.where(outing_id: @outing.id)
    @peoples_availabilities = []
    participants.each do |participant|
      @peoples_availabilities.append(Availability.where(user_id: participant.user_id))
    end

    respond_to do |format|
      format.html { redirect_to set_details_outing_path(@outing) }
      format.js
    end
  end

  def stop_count
    @failed_proposed_events = ProposedEvent.where(outing_id: @outing.id).failed_vote
    @failed_proposed_events.each(&:destroy)

    respond_to do |format|
      format.js
      format.html { redirect_to outing_path(@outing), notice: 'failed proposed events were deleted.' }
      format.json { head :no_content }
    end
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

        format.html { redirect_to set_details_outing_path(@outing), notice: 'Outing was successfully created.' }
        format.json { render :show, status: :created, location: @outing }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @outing.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /outings/1 or /outings/1.json
  def update
    respond_to do |format|
      if @outing.update(outing_params)
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
    @outing.destroy

    respond_to do |format|
      format.html { redirect_to outings_url, notice: 'Outing was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_outing
    @outing = Outing.find_by(invite_token: params[:invite_token])
  end

  def set_participant
    # for proposed event cards
    @participant = @outing.participants.find_by(user: current_user)
  end

  # Only allow a list of trusted parameters through.
  def outing_params
    params.require(:outing).permit(:name, :date, :description, :outing_type, :invite_token)
  end
end
