# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :set_event, only: %i[show edit update destroy approval like]
  before_action :authenticate_user!
  before_action :set_liked, only: %i[show]
  load_and_authorize_resource

  # GET /events or /events.json
  def index
    unless user_signed_in?
      redirect_to '/welcome'
      return
    end

    @events = Event.approved.paginate(page: params[:page], per_page: 6)
    @user_events = Event.user_events(current_user)
    @pending_events = Event.pending_for_user(current_user)

    # order by category interest if no search was performed
    if params[:description].blank? && params[:category_id].blank?
      @events = current_user.commercial ? @events.order_by_category_interest(current_user) : @events
    end

    # @events = @events.page(params[:page])

    return unless user_signed_in?

    @nearby_events = current_user.local_events.approved
    @favourite_category = current_user.category_interests.first.category if current_user.category_interests.any?
    @recommended_events = Event.approved.where(category: @favourite_category) if @favourite_category
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
    if current_user.liked? @event
      @event.unliked_by current_user

    else
      @event.liked_by current_user
    end

    @event_liked_string_sm = @event.decorate.likes(current_user, compressed: true)
    @event_liked_string_lg = @event.decorate.likes(current_user, compressed: false)

    @event_liked = current_user.voted_up_on? @event

    # redirect_to events_path
    respond_to do |format|
      format.html { redirect_to events_path }
      format.js
    end
  end

  # GET /events/search
  def search
    @outing_id = params[:outing_id].to_i

    filter_events_by_content(params)
    @empty_search = params[:description].to_s.strip == ''
    @searched_events = Event.none if @empty_search # Events nil if no search

    # Only responds to remote call and yields a js file
    respond_to do |format|
      format.js # Call search.js.haml
    end
  end

  private

  def filter_events_by_content(search_params)

    word_event_ids = []
    query_list = search_params[:description].to_s.downcase.strip.split

    # go through every word in the query and get the ids of events which match the word
    query_list.each do |word|
      word_events = Event.approved.where('lower(events.description) LIKE :query OR lower(events.name) LIKE :query', query: "%#{word}%")
      word_event_ids.append(word_events.pluck(:id))
    end

    # return events which were present for every word
    search_event_ids = word_event_ids.reduce(:&)

    @searched_events = Event.where(id: search_event_ids)
  end

  def filter_events_by_category
    query_list = params[:query].to_s.downcase.strip.split
    query_list.each do |word|
      category_event_ids = Event.joins(:category).approved.where('lower(categories.name) LIKE :query', query: "%#{word}%").pluck(:id)
      category_events = Event.where(id: category_event_ids)

      @searched_events = @searched_events.or(category_events)
    end
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
