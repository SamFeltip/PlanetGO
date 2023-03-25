# frozen_string_literal: true

class OutingsController < ApplicationController
  before_action :set_outing, only: %i[show edit update destroy set_details]
  before_action :authenticate_user!, only: %i[index show new create destroy edit set_details send_invites]
  load_and_authorize_resource

  # GET /outings or /outings.json
  def index
    @outings = Outing.all.order(date: :desc)
    return if current_user.admin?

    @outings = Outing.joins(:participants).where('participants.user_id' => current_user.id).order(date: :desc)
  end

  # GET /outings/1 or /outings/1.json
  def show; end

  # GET /outings/new
  def new
    @outing = Outing.new
  end

  # GET /outings/1/edit
  def edit; end

  def send_invites
    @friend_ids = params[:user_ids]

    @participants = Participant.none

    @friend_ids = [] if @friend_ids.nil?

    @friend_ids.each do |friend_id|
      # create a participant and add it to the @participants list
      new_participant = Participant.create(user_id: friend_id, outing_id: @outing.id)
      @participants = @participants.or(Participant.where(id: new_participant.id))
    end

    respond_to do |format|
      format.html { redirect_to outings_url, notice: t('.notice') }
      format.js
    end

  end

  # POST /outings or /outings.json
  def create
    @outing = Outing.new(outing_params)

    # There has to be a better way to do this, dont @ me
    token_prefix = @outing.id.to_s
    token = token_prefix + rand(100_000).to_s
    @outing.invitation_token = token.to_i

    # @participant = @outing.participants.new(
    #   user_id: current_user.id,
    #   status: "creator"
    # )

    # @participant.save
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
        Rails.logger.debug 'outing failed'
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @outing.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /outings/1 or /outings/1.json
  def update
    respond_to do |format|
      if @outing.update(outing_params)
        format.html { redirect_to outing_url(@outing), notice: t('.notice') }
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
      format.html { redirect_to outings_url, notice: t('.notice') }
      format.json { head :no_content }
    end
  end

  def set_details
    @variable = 'this is a variable from controller'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_outing
    @outing = Outing.find(params[:id])
    @participants = @outing.participants
  end

  # Only allow a list of trusted parameters through.
  def outing_params
    params.require(:outing).permit(:name, :date, :description, :outing_type, :invitation_token)
  end
end
