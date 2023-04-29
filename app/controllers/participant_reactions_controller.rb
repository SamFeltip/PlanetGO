class ParticipantReactionsController < ApplicationController
  before_action :set_participant_reaction, only: %i[ show edit update destroy ]
  before_action :authenticate_user!
  
  # GET /participant_reactions or /participant_reactions.json
  def index
    @participant_reactions = ParticipantReaction.all
  end

  # GET /participant_reactions/1 or /participant_reactions/1.json
  def show; end

  # GET /participant_reactions/new
  def new
    @participant_reaction = ParticipantReaction.new
  end

  # GET /participant_reactions/1/edit
  def edit; end

  # POST /participant_reactions or /participant_reactions.json
  def create

    # stops a user from liking and disliking an event at the same time, or liking an event multiple times
    ParticipantReaction.where(
      participant_id: participant_reaction_params[:participant_id],
      proposed_event_id: participant_reaction_params[:proposed_event_id]
    ).destroy_all

    @participant_reaction = ParticipantReaction.new(
      participant_id: participant_reaction_params[:participant_id],
      proposed_event_id: participant_reaction_params[:proposed_event_id],
      reaction: params[:reaction]
    )

    @proposed_event = @participant_reaction.proposed_event

    respond_to do |format|
      if @participant_reaction.save
        format.js
        format.html { redirect_to participant_reaction_url(@participant_reaction), notice: "Participant reaction was successfully created." }
        format.json { render :show, status: :created, location: @participant_reaction }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @participant_reaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /participant_reactions/1 or /participant_reactions/1.json
  def update
    respond_to do |format|
      if @participant_reaction.update(participant_reaction_params)
        format.js
        format.html { redirect_to participant_reaction_url(@participant_reaction), notice: "Participant reaction was successfully updated." }
        format.json { render :show, status: :ok, location: @participant_reaction }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @participant_reaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /participant_reactions/1 or /participant_reactions/1.json
  def destroy
    @proposed_event = @participant_reaction.proposed_event
    @participant_reaction.destroy

    respond_to do |format|
      format.html { redirect_to participant_reactions_url, notice: "Participant reaction was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_participant_reaction
      @participant_reaction = ParticipantReaction.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def participant_reaction_params
      params.require(:participant_reaction).permit(:participant_id, :proposed_event_id, :reaction)
    end
end
