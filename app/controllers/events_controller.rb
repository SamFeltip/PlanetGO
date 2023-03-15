class EventsController < ApplicationController
  before_action :set_event, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, only: %i[new create destroy edit like unlike]

  # GET /events or /events.json
  def index
    @events = Event.all
  end

  # GET /events/1 or /events/1.json
  def show
    @users_events = Event.where(user_id: @event.user_id).where.not(id: @event.id).limit(2)
    @event = Event.find(params[:id])
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
      format.html { redirect_to events_path, notice: "Event liked" }
      format.js
    end


  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events or /events.json
  def create
    @event = Event.new(event_params)
    @event.user = current_user

    respond_to do |format|
      if @event.save
        format.html { redirect_to event_url(@event)}
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1 or /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to event_url(@event), notice: "Event was successfully updated." }
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
      format.html { redirect_to events_url, notice: "Event was successfully destroyed." }
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
      params.require(:event).permit(:name, :time_of_event, :description, :category, :approved, :user_id, event_reacts_attributes: [:id, :event_id, :user_id, :status])
    end

end
