# frozen_string_literal: true

class AvailabilitiesController < ApplicationController
  before_action :set_availability, only: %i[update destroy]

  # POST /availabilities or /availabilities.json
  def create
    # skip to the first monday of   1970
    # 86 400 = number of seconds in a day
    start_day = 342_000 + (86_400 * availability_params['start_day'].to_i)
    end_day = 342_000 + (86_400 * availability_params['end_day'].to_i)

    start_time = start_day + (availability_params['start_hour'].to_i * 3600) + (availability_params['start_minute'].to_i * 60)
    end_time = end_day + (availability_params['end_hour'].to_i * 3600) + (availability_params['end_minute'].to_i * 60)

    # If start_time greater than end time, flip them
    start_time, end_time = end_time, start_time if start_time > end_time

    start_time_date = Time.zone.at(start_time).to_datetime
    end_time_date = Time.zone.at(end_time).to_datetime

    all_availabilities = Availability.where('user_id' => current_user.id)

    # If There is an availability which starts sooner and ends later than the new availability, stop
    x_availability = all_availabilities.where('start_time <= ? AND end_time >= ?', start_time_date, end_time_date)
    unless x_availability.empty?
      respond_to do |format|
        format.json { render :show, json: {}, status: :created, location: @availability }
      end
      return
    end

    # Remove all availabilities which are totally within the new availability
    all_availabilities.where('start_time >= ? AND end_time <= ?', start_time_date, end_time_date).destroy_all

    # Remove x availability that ends after the start of the new availability, and move the start of new availability to start of x availability
    x_availability = all_availabilities.where('start_time < ? AND end_time >= ?', start_time_date, start_time_date).limit(1).first
    unless x_availability.nil?
      start_time_date = x_availability['start_time']
      x_availability.destroy
    end

    # Same but for end of new availability
    x_availability = all_availabilities.where('end_time > ? AND start_time <= ?', end_time_date, end_time_date).limit(1).first
    unless x_availability.nil?
      end_time_date = x_availability['end_time']
      x_availability.destroy
    end

    # Create availability
    new_params = { 'user_id' => current_user.id, 'start_time' => start_time_date, 'end_time' => end_time_date }
    @availability = Availability.new(new_params)

    respond_to do |format|
      if @availability.save
        format.json { render json: @availability, layout: false }
      else
        format.json { render json: @availability.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /availabilities/1 or /availabilities/1.json
  def update
    respond_to do |format|
      if @availability.update(availability_params)
        # format.html { redirect_to availability_url(@availability), notice: 'Availability was successfully updated.' }
        format.json { render json: { hello: 1 }, status: :ok }
      else
        # format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @availability.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /availabilities/1 or /availabilities/1.json
  def destroy
    @availability.destroy
    respond_to do |format|
      format.json { render json: {}, status: :ok }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_availability
    @availability = Availability.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def availability_params
    params.permit(:id, :authenticity_token, :start_day, :end_day, :start_hour, :start_minute, :end_hour, :end_minute)
  end
end
