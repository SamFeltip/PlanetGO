# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :set_event, only: %i[show edit update destroy approval like]
  before_action :authenticate_user!
  before_action :set_liked, only: %i[show]
  load_and_authorize_resource

  # GET /events or /events.json
  def index
    @events = Event.approved
    @user_events = Event.user_events(current_user)
    @pending_events = Event.pending_for_user(current_user)

    filter_events_by_name_or_description
    filter_events_by_category

    # order by category interest if no search was performed
    if params[:description].blank? && params[:category_id].blank?
      @events = current_user.commercial ? @events.order_by_category_interest(current_user) : @events
    end

    @events = @events.page(params[:page])
  end

  # GET /events/1 or /events/1.json
  def show
    @event = Event.find(params[:id]).decorate
    @more_events = Event.approved.where(category_id: @event.category_id).where.not(id: @event.id).limit(3)
  end

  def approval
    @event.update(approved: params[:approved])

    @approved_events = Event.approved

    # redirect_to events_path
    respond_to do |format|
      format.html { redirect_to events_path }
      format.js
    end
  end

  def like
    if current_user.liked(@event)
      event_react_id = EventReact.where(user_id: current_user.id, event_id: @event.id, status: EventReact.statuses[:like]).pluck(:id)
      EventReact.destroy(event_react_id)

    else
      @event.event_reacts.create(
        user_id: current_user.id,
        status: EventReact.statuses[:like]
      )
    end

    @event_liked = current_user.liked(@event)

    # redirect_to events_path
    respond_to do |format|
      format.html { redirect_to events_path }
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
        format.html { redirect_to events_url, notice: 'Event was created and is under review.' }
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
        format.html { redirect_to event_url(@event) }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /events/search
  def search
    @events = Event.approved
    @outing = Outing.where(id: params[:outing_id]).first # Get the outing being searched from

    filter_events_by_name_or_description
    filter_events_by_category

    @events = nil if params[:description].to_s.strip == '' # Events nil if no search

    # Only responds to remote call and yields a js file
    respond_to do |format|
      format.js # Call search.js.haml
    end
  end

  # DELETE /events/1 or /events/1.json
  def destroy
    @event.destroy

    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def filter_events_by_name_or_description
    @description = params[:description].to_s.downcase.strip
    return if @description.blank?

    @events = @events.where('lower(description) LIKE :query OR lower(name) LIKE :query', query: "%#{@description}%")
  end

  def filter_events_by_category
    @category_id = params[:category_id].to_i
    return if @category_id.zero?

    @events = @events.where(category_id: @category_id)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_event
    @event = Event.find(params[:id])
  end

  def set_liked
    @event_liked = current_user.liked(@event)
  end

  # Only allow a list of trusted parameters through.
  def event_params
    params.require(:event).permit(:name, :address_line1, :address_line2, :town, :postcode, :time_of_event, :description, :category_id, :approved, :user_id,
                                  event_reacts_attributes: %i[id event_id user_id status])
  end
end
