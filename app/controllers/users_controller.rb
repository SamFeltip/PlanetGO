# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]
  before_action :authenticate_user!, only: %i[index show edit update destroy]
  load_and_authorize_resource
  
  def index
    @users = User.accessible_by(current_ability)
  end

  def show
    @user = User.find_by(id: params[:id])
  end

  # GET /users/1/edit
  def edit; end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      unless @user.commercial
        params[:suspended] = false # Event suspension not for admins/reporters
      end
      if @user.update(user_params)
        # redirect_to users_path, notice: "User was successfully updated but in a sexy way."
        format.html { redirect_to users_path, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:full_name, :email, :role, :suspended)
  end
end
