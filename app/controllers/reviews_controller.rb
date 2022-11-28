class ReviewsController < ApplicationController
  before_action :set_review, only: %i[ show destroy like unlike edit update]
  before_action :authenticate_user!, only: [:new, :create, :destroy, :edit, :like, :unlike]

  # GET /reviews or /reviews.json
  def index
    @reviews = Review.all
  end

  # GET /reviews/1 or /reviews/1.json
  def show
  end

  # GET /reviews/new
  def new
    @review = Review.new
  end

  def edit
    authorize! :edit, @review
    # @review = Review.find_by_id(params[:id])

  end

  # PATCH/PUT /reviews/1 or /reviews/1.json
  def update
    authorize! :update, @review
    # @review = Review.find_by_id(params[:id])

    respond_to do |format|
      if @review.update(review_params)
        format.html { redirect_to reviews_path, notice: "Review was successfully updated." }
        format.json { render :show, status: :ok, location: @review }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /reviews or /reviews.json
  def create
    @review = Review.new(review_params)
    @review.user = current_user 
    @review.is_on_landing_page = false

    respond_to do |format|
      if @review.save
        format.html { redirect_to review_url(@review), notice: "Review was successfully created." }
        format.json { render :show, status: :created, location: @review }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reviews/1 or /reviews/1.json
  def destroy
    @review.destroy

    respond_to do |format|
      format.html { redirect_to reviews_url, notice: "Review was successfully deleted." }
      format.json { head :no_content }
    end
  end

  def like
    @review.liked_by current_user

    respond_to do |format|
      format.html { redirect_to review_url(@review) }
      format.json { head :no_content }
    end
  end

  def unlike
    @review.unliked_by current_user

    respond_to do |format|
      format.html { redirect_to review_url(@review) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_review
      @review = Review.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def review_params
      params.require(:review).permit(:body, :user_id, :is_on_landing_page)
    end
end
