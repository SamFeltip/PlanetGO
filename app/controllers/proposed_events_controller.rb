# frozen_string_literal: true

class ProposedEventsController < ApplicationController
  before_action :set_proposed_event, only: %i[show edit update destroy]

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

  # GET /proposed_events/1/edit
  def edit; end

  # POST /proposed_events or /proposed_events.json
  def create
    @proposed_event = ProposedEvent.new(proposed_event_params)

    respond_to do |format|
      if @proposed_event.save
        format.js
        format.html do
          redirect_to set_details_outing_path(@proposed_event.outing, position: 'where'), notice: t('.notice')
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
        format.html do
          redirect_to proposed_event_url(@proposed_event), notice: t('.notice')
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
    @proposed_event.destroy

    respond_to do |format|
      format.html { redirect_to proposed_events_url, notice: t('.notice') }
      format.json { head :no_content }
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
