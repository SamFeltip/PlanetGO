class RegisterInterestsController < ApplicationController
  before_action :set_register_interest, only: %i[ show edit update destroy ]

  # GET /register_interests or /register_interests.json
  def index
    @register_interests = RegisterInterest.all
  end

  # GET /register_interests/1 or /register_interests/1.json
  def show
  end

  # GET /register_interests/new
  def new
    @register_interest = RegisterInterest.new
  end

  # GET /register_interests/1/edit
  def edit
  end

  # POST /register_interests or /register_interests.json
  def create
    @register_interest = RegisterInterest.new(register_interest_params)

    respond_to do |format|
      if @register_interest.save
        format.html { redirect_to register_interest_url(@register_interest), notice: "Register interest was successfully created." }
        format.json { render :show, status: :created, location: @register_interest }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @register_interest.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /register_interests/1 or /register_interests/1.json
  def update
    respond_to do |format|
      if @register_interest.update(register_interest_params)
        format.html { redirect_to register_interest_url(@register_interest), notice: "Register interest was successfully updated." }
        format.json { render :show, status: :ok, location: @register_interest }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @register_interest.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /register_interests/1 or /register_interests/1.json
  def destroy
    @register_interest.destroy

    respond_to do |format|
      format.html { redirect_to register_interests_url, notice: "Register interest was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_register_interest
      @register_interest = RegisterInterest.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def register_interest_params
      params.require(:register_interest).permit(:email)
    end
end
