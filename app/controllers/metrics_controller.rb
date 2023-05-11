# frozen_string_literal: true

class MetricsController < ApplicationController
  include DBQueries
  include MetricsGraphHelper
  include Geocoder
  before_action :set_metric, only: %i[show edit update destroy]
  before_action :authenticate_user!, only: %i[show edit update destroy]
  load_and_authorize_resource only: %i[index show edit update destroy]

  # GET /metrics or /metrics.json
  def index
    metrics = Metric.all
    routes_interested_in = ['/', '/metrics', '/users', '/users/new', '/users/#',
                            '/users/#/edit', '/users/sign_in', '/users/sign_up', '/users/unlock',
                            '/users/unlock/new', '/users/password/new', '/users/password/edit',
                            '/users/cancel', '/users/sign_up', '/users/edit', '/bug_reports',
                            '/bug_reports/new', '/bug_reports/#', '/categories', '/categories/new',
                            '/categories/#', '/availabilities', '/availabilities/new',
                            '/availabilities/#', '/proposed_events/new', '/proposed_events/#',
                            '/proposed_events/#/create', '/proposed_events/#/edit',
                            '/events', '/events/#', '/events/#/like', '/outings', '/outings/new',
                            '/outings/#', '/outings/#/set_details', '/outings/#/send_invites',
                            '/events', '/events/new', '/events/#', '/events/#/approval/approved',
                            '/participants', '/participants/new', '/participants/#', '/participants/#/edit',
                            '/outings', '/outings/new', '/outings/#', '/outings/#/edit',
                            '/category_interests', '/myaccount', '/home', '/welcome', '/friends',
                            '/friends/search', '/friends/requests']

    @all_metrics = []
    routes_interested_in.each do |route|
      metrics_list = metrics.where(route:)
      @all_metrics.append({ 'route' => route, 'metrics' => get_common_metrics(metrics_list) })
    end

    @landing_page_visits_last_7_days, @landing_page_visits_7_days_before_that, @percent_difference = main_visit_information

    # Count for each country number of visits to the landing page. Countries with no visits not included in generated data object
    country_codes_metrics = metrics.where(route: '/').where.not(country_code: [nil, '']).order(:country_code)
    country_codes_data = country_codes_metrics.group(:country_code).count
    @click_data = JSON.generate(country_codes_data)

    @data_keys, @data_values = empty_graph

    # List of all categories for the categories graph
    @category_select_values = Category.distinct.pluck(:name)
    return unless params['start'] && params['end']

    if params['category']
      @data_keys, @data_values = handle_graph_category(params['start'], params['end'], params['resolution'], params['category'])
    else
      @data_keys, @data_values = handle_graph_metric(params['start'], params['end'], params['resolution'], params['page'],
                                                     params['metric'])
    end
  end

  # GET /metrics/new
  def new
    @metric = Metric.new
  end

  # POST /metrics or /metrics.json
  def create
    time_enter = Time.zone.at(params['time_enter'].to_i / 1000).to_datetime
    time_exit = Time.zone.at(params['time_exit'].to_i / 1000).to_datetime

    country_code = if !params['latitude'].nil? && !params['longitude'].nil?
                     Geocoder.search([params['latitude'], params['longitude']]).first.country_code.upcase.to_s
                   end

    Metric.create(
      time_enter:,
      time_exit:,
      route: params['route'],
      latitude: params['latitude'],
      longitude: params['longitude'],
      country_code:,
      is_logged_in: params['is_logged_in'],
      number_interactions: params['number_interactions']
    )

    head :ok
  end

  # PATCH/PUT /metrics/1 or /metrics/1.json
  def update
    respond_to do |format|
      if @metric.update(metric_params)
        format.html { redirect_to metric_url(@metric), notice: 'Metric was successfully updated.' }
        format.json { render :show, status: :ok, location: @metric }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @metric.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_metric
    @metric = Metric.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def metric_params
    params.require(:metric).permit(:time_enter, :time_exit, :route, :lattitude, :longitude, :is_logged_in,
                                   :number_interactions, :country_code)
  end
end
