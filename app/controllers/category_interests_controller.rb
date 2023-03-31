class CategoryInterestsController < ApplicationController
  before_action :set_category_interest, only: %i[ show edit update destroy ]

  # GET /category_interests or /category_interests.json
  def index
    @category_interests = CategoryInterest.where(user_id: current_user.id)
  end

  # GET /category_interests/1 or /category_interests/1.json
  def show
  end

  # GET /category_interests/new
  def new
    @category_interest = CategoryInterest.new
  end

  # GET /category_interests/1/edit
  def edit
  end

  # POST /category_interests or /category_interests.json
  def create
    @category_interest = CategoryInterest.new(category_interest_params)

    respond_to do |format|
      if @category_interest.save
        format.html { redirect_to category_interest_url(@category_interest), notice: 'Category interest was successfully created.' }
        format.json { render :show, status: :created, location: @category_interest }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @category_interest.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /category_interests/1 or /category_interests/1.json
  def update
    respond_to do |format|
      if @category_interest.update(category_interest_params)
        format.html { redirect_to category_interest_url(@category_interest), notice: 'Category interest was successfully updated.' }
        format.json { render :show, status: :ok, location: @category_interest }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @category_interest.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /category_interests/1 or /category_interests/1.json
  def destroy
    @category_interest.destroy

    respond_to do |format|
      format.html { redirect_to category_interests_url, notice: 'Category interest was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def like
    @category_interest = CategoryInterest.find(params[:id])
    @category_interest.update(interest: 1)
  end

  def dislike
    @category_interest = CategoryInterest.find(params[:id])

    @category_interest.update(interest: -1)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_category_interest
    @category_interest = CategoryInterest.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def category_interest_params
    params.require(:category_interest).permit(:category_id, :user_id, :interest)
  end
end
