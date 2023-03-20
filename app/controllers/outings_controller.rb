# frozen_string_literal: true

class OutingsController < ApplicationController
  before_action :set_outing, only: %i[show edit update destroy]
  before_action :authenticate_user!, only: %i[index show new create destroy edit]
  load_and_authorize_resource

  # GET /outings or /outings.json
  def index

    @outings = Outing.all.order(date: :desc)
    unless current_user.admin?
      @outings = Outing.joins(:participants).where("participants.user_id" => current_user.id).order(:date)
    end

  end

  # GET /outings/1 or /outings/1.json
  def show
  end

  # GET /outings/new
  def new
    @outing = Outing.new
  end

  # GET /outings/1/edit
  def edit
  end

  # POST /outings or /outings.json
  def create
    @outing = Outing.new(outing_params)

    # There has to be a better way to do this, dont @ me
    token_prefix = @outing.id.to_s
    token = token_prefix + rand(100000).to_s
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

        format.html { redirect_to outings_path, notice: "Outing was successfully created." }
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
        format.html { redirect_to outing_url(@outing), notice: 'Outing was successfully updated.' }
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
    @outing = Outing.find(params[:id])
    @participants = @outing.participants
  end

  # Only allow a list of trusted parameters through.
  def outing_params
    params.require(:outing).permit(:name, :date, :description, :outing_type, :invitation_token)
  end
end
