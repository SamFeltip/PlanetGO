# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :set_event, only: %i[show edit update destroy]
  before_action :authenticate_user!, only: %i[index show new create destroy edit like]

  # GET /events or /events.json
  def index
    @approved_events = Event.where(approved: true)

    @my_pending_events = Event.my_pending_events(current_user)
    @all_pending_events = Event.other_users_pending_events(current_user)
  end

  # GET /events/1 or /events/1.json
  def show
    @users_events = Event.where(user_id: @event.user_id, approved: true).where.not(id: @event.id).limit(3)

    @event = Event.find(params[:id])
    @event_decorate = @event.decorate
  end

  def approval
    @event = Event.find(params[:id])
    @event.approved = params[:approved]
    @event.save

    @approved_events = Event.where(approved: true)

    # redirect_to posts_path
    respond_to do |format|
      format.html { redirect_to events_path, notice: t('.notice') }
      format.js
    end
  end

  def like
    @event = Event.find(params[:id])

    if current_user.liked(@event)
      event_react_id = EventReact.where(user_id: current_user.id, event_id: @event.id, status: EventReact.statuses[:like]).pluck(:id)
      EventReact.destroy(event_react_id)

    else
      @event_react = @event.event_reacts.build(
        user_id: current_user.id,
        status: EventReact.statuses[:like]
      )

      @event.save
    end

    @event_liked = current_user.liked(@event)

    # redirect_to posts_path
    respond_to do |format|
      format.html { redirect_to events_path, notice: t('.notice') }
      format.js
    end
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit; end

  # POST /events or /events.json
  def create
    @event = Event.new(event_params)
    @event.user_id = current_user.id if current_user
    respond_to do |format|
      if @event.save
        format.html { redirect_to events_url, notice: t('.notice') }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1 or /events/1.json
  def update
    # any changes need to be approved by admins
    @event.approved = nil if @event.creator == current_user

    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to event_url(@event), notice: t('.notice') }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1 or /events/1.json
  def destroy
    @event.destroy

    respond_to do |format|
      format.html { redirect_to events_url, notice: t('.notice') }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_event
    @event = Event.find(params[:id])
    @event_liked = current_user.liked(@event)
  end

  # Only allow a list of trusted parameters through.
  def event_params
    params.require(:event).permit(:name, :address_line1, :address_line2, :town, :postcode, :time_of_event, :description, :category_id, :approved, :user_id,
                                  event_reacts_attributes: %i[id event_id user_id status])
  end
end
