# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy lock unlock suspend reinstate]
  before_action :authenticate_user!, only: %i[index show edit update destroy lock unlock suspend reinstate]
  load_and_authorize_resource

  def index
    raise CanCan::AccessDenied.new('You are not authorized to access this page.', :read, User) unless current_user.admin?

    @users = User.accessible_by(current_ability).order(:id)

    @query = params[:description]

    @users = @users.where('lower(full_name) LIKE :query OR lower(email) LIKE :query', query: "%#{@query.to_s.strip.downcase}%")

    @users = @users.page(params[:page]).per_page(25)
  end

  def show
    raise CanCan::AccessDenied.new('You are not authorized to access this page.', :read, User) unless current_user.admin?

    @user = User.find_by(id: params[:id])
  end

  # GET /users/1/edit
  def edit; end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
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

  def lock
    @user.lock_access!({ send_instructions: false })

    respond_to do |format|
      format.html { redirect_to users_path, notice: 'User was successfully updated.' }
      format.json { render :show, status: :ok, location: @user }
    end
  end

  def unlock
    @user.unlock_access!

    respond_to do |format|
      format.html { redirect_to users_path, notice: 'User was successfully updated.' }
      format.json { render :show, status: :ok, location: @user }
    end
  end

  def suspend
    respond_to do |format|
      if @user.commercial
        @user.update(suspended: true)
        format.html { redirect_to users_path, notice: 'User was successfully suspended' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      else
        format.html { redirect_to users_path, alert: 'Cannot suspend a non-commercial user' }
        format.json { render :show, status: :ok, location: @user }
      end
    end
  end

  def reinstate
    @user.update(suspended: false)

    respond_to do |format|
      format.html { redirect_to users_path, notice: 'User was successfully updated.' }
      format.json { render :show, status: :ok, location: @user }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:full_name, :email, :postcode, :role, :description)
  end
end
