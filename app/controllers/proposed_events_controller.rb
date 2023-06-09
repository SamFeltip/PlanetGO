# frozen_string_literal: true

class ProposedEventsController < ApplicationController
  before_action :set_proposed_event, only: %i[show edit update destroy vote]
  before_action :authenticate_user!

  # GET /proposed_events or /proposed_events.json
  def index
    @proposed_events = ProposedEvent.all
  end

  # GET /proposed_events/1 or /proposed_events/1.json
  def show; end

  # GET /proposed_events/new
  def new
    @proposed_event = ProposedEvent.new
  end

  def vote
    if current_user.voted_up_on? @proposed_event
      # unlike the proposed_event
      @proposed_event.unliked_by current_user
    else
      @proposed_event.liked_by current_user
    end

    respond_to do |format|
      format.js
      format.html do
        redirect_to outing_path(@proposed_event.outing), notice: 'Vote was successfully cast.'
      end
    end
  end

  # GET /proposed_events/1/edit
  def edit; end

  # POST /proposed_events or /proposed_events.json
  def create
    @proposed_event = ProposedEvent.new(proposed_event_params)
    @event = @proposed_event.event
    @outing = @proposed_event.outing

    @proposed_event.proposed_datetime = @event.time_of_event

    # for proposed event cards
    @participant = Participant.find_by(user_id: current_user.id, outing_id: @outing.id)

    respond_to do |format|
      if @proposed_event.save
        format.js
        format.html do
          redirect_to set_details_outing_path(@proposed_event.outing, position: 'where')
        end
        format.json { render :show, status: :created, location: @proposed_event }

      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @proposed_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /proposed_events/1 or /proposed_events/1.json
  def update
    respond_to do |format|
      if @proposed_event.update(proposed_event_params)
        format.js
        format.html do
          redirect_to proposed_event_url(@proposed_event)
        end
        format.json { render :show, status: :ok, location: @proposed_event }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @proposed_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /proposed_events/1 or /proposed_events/1.json
  def destroy
    @outing = @proposed_event.outing
    @event = @proposed_event.event
    @proposed_event.destroy

    respond_to do |format|
      format.html { redirect_to proposed_events_url }
      format.json { head :no_content }
      format.js
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_proposed_event
    @proposed_event = ProposedEvent.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def proposed_event_params
    params.require(:proposed_event).permit(:event_id, :outing_id, :proposed_datetime, :status)
  end
end
