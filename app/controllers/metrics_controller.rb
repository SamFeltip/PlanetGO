# frozen_string_literal: true

class MetricsController < ApplicationController
  include DBQueries
  include MetricsGraphHelper
  include Geocoder
  before_action :set_metric, only: %i[show edit update destroy]
  authorize_resource only: %i[index show edit update destroy]
  # GET /metrics or /metrics.json
  def index
    metrics = Metric.all
    register_interests = RegisterInterest.all
    routes_interested_in = ['/', '/metrics',
                            '/users', '/users/#', '/users/new', '/users/#/edit',
                            '/users/sign_in', '/users/sign_up', '/users/unlock/new',
                            '/users/password/new']

    # lists all routes of application. Way too many to display metrics for. Need to specify pages manually
    # p Rails.application.routes.routes.map { |r| {alias: r.name, path: r.path.spec.to_s, controller: r.defaults[:controller], action: r.defaults[:action]}}

    @all_metrics = []
    routes_interested_in.each do |route|
      metrics_list = metrics.where(route:)
      @all_metrics.append({ 'route' => route, 'metrics' => get_common_metrics(metrics_list) })
    end

    @number_landing_page_visits = metrics.where(route: '/').count.to_s
    @number_pricing_page_bounce_outs = get_number_pricing_page_bounce_outs(metrics, register_interests, nil, nil).to_s

    # Calculates the two Interests metrics
    basic_plan_interest = get_pricing_interest(register_interests, 'basic', nil, nil)
    premium_plan_interest = get_pricing_interest(register_interests, 'premium', nil, nil)
    premium_plus_plan_interest = get_pricing_interest(register_interests, 'premium_plus', nil, nil)
    total_interest = basic_plan_interest + premium_plan_interest + premium_plus_plan_interest

    @interest_in_pricing_options = "#{basic_plan_interest}:#{premium_plan_interest}:#{premium_plus_plan_interest}"
    @interest_in_pricing_options_percent = '0%:0%:0%'
    if total_interest.positive?
      # Use default percentages instead of dividing by zero
      @interest_in_pricing_options_percent = "#{basic_plan_interest * 100 / total_interest}:#{premium_plan_interest * 100 / total_interest}:#{premium_plus_plan_interest * 100 / total_interest}"
    end

    # Count for each country number of visits to the landing page. Countries with no visits not included in generated data object
    country_codes_metrics = metrics.where(route: '/').where.not(country_code: [nil, '']).order(:country_code)
    country_codes_data = country_codes_metrics.group(:country_code).count
    @click_data = JSON.generate(country_codes_data)

    @data_keys, @data_values = empty_graph
    return unless params['start'] && params['end']

    @data_keys, @data_values = handle_graph(params['start'], params['end'], params['resolution'], params['page'],
                                            params['metric'])
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
      number_interactions: params['number_interactions'],
      pricing_selected: params['pricing_selected']
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
                                   :number_interactions, :pricing_selected, :country_code)
  end
end
