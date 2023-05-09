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

    # order by category interest if no search was performed
    if params[:description].blank? && params[:category_id].blank?
      @events = current_user.commercial ? @events.order_by_category_interest(current_user) : @events
    end

    # @events = @events.page(params[:page])

    if user_signed_in?
      @nearby_events = current_user.local_events
      @favourite_category = current_user.category_interests.first.category if current_user.category_interests.any?
      @recommended_events = Event.where(category: @favourite_category) if @favourite_category
    end
  end

  # GET /events/1 or /events/1.json
  def show
    @event = Event.find(params[:id]).decorate
    @more_events = Event.approved.where(category_id: @event.category_id).where.not(id: @event.id).limit(3)
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

  # DELETE /events/1 or /events/1.json
  def destroy
    @event.destroy

    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
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

    @event_liked_string_sm = @event.decorate.likes(current_user, compressed: true)
    @event_liked_string_lg = @event.decorate.likes(current_user, compressed: false)

    @event_liked = current_user.liked(@event)

    # redirect_to events_path
    respond_to do |format|
      format.html { redirect_to events_path }
      format.js
    end
  end

  def search

    filter_events_by_content
    filter_events_by_category

    respond_to do |format|
      format.html { redirect_to events_path }
      format.js
    end
  end

  private

  def filter_events_by_content
    @query = params[:query].to_s.downcase.strip
    return if @query.blank?

    @searched_events = Event.approved.where('lower(description) LIKE :query OR lower(name) LIKE :query', query: "%#{@query}%")
  end

  def filter_events_by_category
    category_id = params[:category_id].to_i
    return if category_id.zero?

    @searched_events = @searched_events.where(category_id: @category_id)
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
    params.require(:event).permit(:query, :name, :address_line1, :address_line2, :town, :postcode, :time_of_event, :description, :category_id, :approved, :user_id,
                                  event_reacts_attributes: %i[id event_id user_id status])
  end
end
