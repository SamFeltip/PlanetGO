# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :set_event, only: %i[show edit update destroy approval like]
  before_action :authenticate_user!, only: %i[new create edit update destroy approval like]
  before_action :set_liked, only: %i[show like]
  load_and_authorize_resource except: [:index]

  # GET /events or /events.json
  def index
    @events = Event.approved.paginate(page: params[:page]).includes([:category])

    return unless user_signed_in?

    # order by category interest if no search was performed
    if params[:description].blank?
      @events = current_user.commercial ? @events.order_by_category_interest(current_user) : @events
    end

    @nearby_events = current_user.local_events.approved.includes([:category])
    @favourite_category = current_user.category_interests.order(interest: :desc).first.category if current_user.category_interests.any?
    @recommended_events = Event.approved.includes([:category]).where(category: @favourite_category).limit(5) if @favourite_category
    @liked_events = current_user.liked_events.paginate(page: params[:page], per_page: 2)

    expires_in 5.minutes, public: true
  end

  # GET /events/1 or /events/1.json
  def show
    @event = Event.find(params[:id]).decorate
    @more_events = Event.approved.where(category_id: @event.category_id).where.not(id: @event.id).limit(3).includes([:category])
    expires_in 30.minutes, public: true
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit; end

  # POST /events or /events.json
  def create
    # get event_params and upcase the postcode, and save it to event params
    event_params[:postcode].upcase!

    @event = Event.new(event_params)
    @event.user_id = current_user.id if current_user
    respond_to do |format|
      if @event.save
        format.html { redirect_to events_manage_path, notice: 'Event was created and is under review.' }
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
      format.html { redirect_to events_manage_path }
      format.js
    end
  end

  def like
    if current_user.liked? @event
      @event.unliked_by current_user

    else
      @event.liked_by current_user
    end

    @event_liked_string_sh = @event.decorate.likes(current_user:, compressed: true)
    @event_liked_string_lg = @event.decorate.likes(current_user:, compressed: false)

    # redirect_to events_path
    respond_to do |format|
      format.html { redirect_to events_path }
      format.js
    end
  end

  # GET /events/search
  def search
    @searched_events = Event.approved.includes(:category)
    @searched_events = filter_events_by_content(@searched_events, params)
    @searched_events = filter_events_by_category(@searched_events, params)

    @empty_search = params[:description].to_s.strip == ''

    add_to_outing = params[:add_to_outing] == 'true'

    @add_to_outing_params = { outing_id: params[:outing_id].to_i, add_event_to_outing: add_to_outing, hide_likes: add_to_outing }

    # Only responds to remote call and yields a js file
    respond_to do |format|
      format.js # Call search.js.haml
      if add_to_outing
        format.html { redirect_to set_details_outing_path(params[:outing_id], description: params[:description], position: 'where') }
      else
        format.html { redirect_to events_path(description: params[:description]) }
      end
    end
  end

  def manage_search
    @events = Event.user_events(current_user).includes(:category) if current_user.advertiser?

    @events = Event.includes(:category) if current_user.admin?

    # if search query is empty, show all events
    @events = filter_events_by_content(@events, params) unless params[:description].to_s.strip == ''

    @events = @events.where(category_id: params[:category_id]) if params[:category_id].present?

    # Only responds to remote call and yields a js file
    respond_to do |format|
      format.html { redirect_to events_manage_path }
      format.js # Call manage_search.js.haml
    end
  end

  def manage
    @user_pending_events = Event.user_pending_events(current_user)
    @pending_events = Event.pending_for_review(current_user).includes([:user])

    @events = Event.user_events(current_user).includes([:category]) if current_user.advertiser?

    @events = Event.includes([:category]) if current_user.admin?
  end

  private

  # takes in a search query
  # returns a list of events which match every word in the search query
  def filter_events_by_content(events, search_params)
    query_list = search_params[:description].to_s.downcase.strip.split

    return Event.none if query_list.empty?

    # go through every word in the query and get the ids of events which match the word
    query_list.each do |word|
      events = events.where('lower(events.description) LIKE :query OR lower(events.name) LIKE :query', query: "%#{word}%")
    end
    events
  end

  # takes in a list of searched for events plus a search query
  # returns this list plus any events with a category matching one of the words in the search query
  def filter_events_by_category(events, params)
    query_list = params[:description].to_s.downcase.strip.split

    query_list.each do |word|
      category_ids = Category.where('lower(name) LIKE :query', query: "%#{word}%").pluck(:id)
      category_events = Event.where(category_id: category_ids)

      events = events.or(category_events)
    end

    events
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_event
    @event = Event.find(params[:id])
  end

  def set_liked
    @event_liked = user_signed_in? ? current_user.liked(@event) : false
  end

  # Only allow a list of trusted parameters through.
  def event_params
    params.require(:event).permit(:colour, :add_to_outing, :name, :address_line1, :address_line2, :town, :postcode,
                                  :time_of_event, :description, :category_id, :approved, :user_id)
  end
end
