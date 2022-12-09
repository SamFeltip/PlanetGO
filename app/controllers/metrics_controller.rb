class MetricsController < ApplicationController
  include DBQueries
  include Geocoder
  before_action :set_metric, only: %i[show edit update destroy]
  authorize_resource only: %i[index show edit update destroy]
  # GET /metrics or /metrics.json
  def index
    def handleGraph
      start_date_array = params['start'].split('-')
      end_date_array = params['end'].split('-')

      # Calculate start end Time objects. Default is one month ago and now respectively
      start_date_time_stamp = Time.now - 1.month
      end_date_time_stamp = Time.now
      if start_date_array.length == 3
        start_date_time_stamp = Time.new(start_date_array[0], start_date_array[1], start_date_array[2])
      end
      end_date_time_stamp = Time.new(end_date_array[0], end_date_array[1], end_date_array[2]) if end_date_array.length == 3

      # Get date increment from params. Default is one day if no param passed
      date_increment = 1.day
      if params['resolution'] == 'Month'
        date_increment = 1.month
      elsif params['resolution'] == 'Year'
        date_increment = 1.year
      end

      register_interests = RegisterInterest.all
      metrics = Metric.where(route: '/')
      metrics = Metric.where(route: params['page']) if params['page']

      @data_keys = []
      @data_values = []

      # TODO: Is there a way to make this more DRY?
      case params['metric']
      when '# visits', 'Total number of landing page visits'
        data = []
        while start_date_time_stamp < end_date_time_stamp
          @data_keys.append(start_date_time_stamp.strftime('%F'))
          data.append(getNumberOfVisits(metrics, start_date_time_stamp, start_date_time_stamp + date_increment))
          start_date_time_stamp += date_increment
        end

        @data_values = JSON.generate([{ label: '# visits', data: }])
      when 'x̄ # clicks/visit'
        data = []
        while start_date_time_stamp < end_date_time_stamp
          @data_keys.append(start_date_time_stamp.strftime('%F'))
          data.append(getNumberOfInteractionsPerVisit(metrics, start_date_time_stamp, start_date_time_stamp + date_increment))
          start_date_time_stamp += date_increment
        end

        @data_values = JSON.generate([{ label: 'x̄ # clicks/visit', data: }])
      when 'x̄ time on page'
        data = []
        while start_date_time_stamp < end_date_time_stamp
          @data_keys.append(start_date_time_stamp.strftime('%F'))
          data.append(getAverageTimeSpent(metrics, start_date_time_stamp, start_date_time_stamp + date_increment))
          start_date_time_stamp += date_increment
        end

        @data_values = JSON.generate([{ label: 'x̄ time on page', data: }])
      when 'Pricing page bounce outs'
        data = []
        while start_date_time_stamp < end_date_time_stamp
          @data_keys.append(start_date_time_stamp.strftime('%F'))
          data.append(getNumberPricingPageBounceOuts(metrics, register_interests, start_date_time_stamp,
                                                     start_date_time_stamp + date_increment))
          start_date_time_stamp += date_increment
        end

        @data_values = JSON.generate([{ label: 'Pricing page bounce outs', data: }])
      when 'Interest in pricing options Basic:Premium:Premium+ Total'
        pricing_interest = RegisterInterest.all
        basic = []
        premium = []
        premium_plus = []
        while start_date_time_stamp < end_date_time_stamp
          @data_keys.append(start_date_time_stamp.strftime('%F'))
          basic.append(getPricingInterest(pricing_interest, 'basic', start_date_time_stamp,
                                          start_date_time_stamp + date_increment))
          premium.append(getPricingInterest(pricing_interest, 'premium', start_date_time_stamp,
                                            start_date_time_stamp + date_increment))
          premium_plus.append(getPricingInterest(pricing_interest, 'premium_plus', start_date_time_stamp,
                                                 start_date_time_stamp + date_increment))
          start_date_time_stamp += date_increment
        end
        @data_values = JSON.generate([{ label: 'Basic', data: basic }, { label: 'Premium', data: premium },
                                      { label: 'Premium+', data: premium_plus }])
      when 'Interest in pricing options Basic:Premium:Premium+ Percent'
        pricing_interest = RegisterInterest.all
        basic = []
        premium = []
        premium_plus = []
        while start_date_time_stamp < end_date_time_stamp
          @data_keys.append(start_date_time_stamp.strftime('%F'))
          basic_value = getPricingInterest(pricing_interest, 'basic', start_date_time_stamp,
                                          start_date_time_stamp + date_increment)
          premium_value = getPricingInterest(pricing_interest, 'premium', start_date_time_stamp,
                                            start_date_time_stamp + date_increment)
          premium_plus_value = getPricingInterest(pricing_interest, 'premium_plus', start_date_time_stamp,
                                                start_date_time_stamp + date_increment)
          total = basic_value + premium_value + premium_plus_value
          total = 1 if total == 0

          basic.append((basic_value * 100) / total)
          premium.append((premium_value * 100) / total)
          premium_plus.append((premium_plus_value * 100) / total)

          start_date_time_stamp += date_increment
        end
        @data_values = JSON.generate([{ label: 'Basic', data: basic }, { label: 'Premium', data: premium },
                                      { label: 'Premium+', data: premium_plus }])
      else
        # No metric selected by the user, display a slash accross the graph with a label "No Data"
        emptyGraph
      end
    end

    def emptyGraph
      @data_keys = [0, 1]
      @data_values = JSON.generate([{ label: 'No Data', data: [1, 0] }])
    end

    metrics = Metric.all
    register_interests = RegisterInterest.all
    routes_interested_in = ['/', '/metrics',
                          '/reviews', '/reviews/#', '/reviews/new', '/reviews/#/edit',
                          '/faqs', '/faqs/#', '/faqs/new', '/faqs/#/edit',
                          '/users', '/users/#', '/users/new', '/users/#/edit',
                          '/users/sign_in', '/users/sign_up', '/users/unlock/new',
                          '/users/password/new']

    # lists all routes of application. Way too many to display metrics for. Need to specify pages manually
    # p Rails.application.routes.routes.map { |r| {alias: r.name, path: r.path.spec.to_s, controller: r.defaults[:controller], action: r.defaults[:action]}}

    @all_metrics = []
    routes_interested_in.each do |route|
      metrics_list = metrics.where(route:)
      num_metrics = metrics_list.count
      @all_metrics.append({ 'route' => route, 'metrics' => getCommonMetrics(metrics_list, num_metrics) })
    end

    @number_landing_page_visits = metrics.where(route: '/').count.to_s
    @number_pricing_page_bounce_outs = getNumberPricingPageBounceOuts(metrics, register_interests, nil, nil).to_s

    # Calculates the two Interests metrics
    basic_plan_interest = getPricingInterest(register_interests, 'basic', nil, nil)
    premium_plan_interest = getPricingInterest(register_interests, 'premium', nil, nil)
    premium_plus_plan_interest = getPricingInterest(register_interests, 'premium_plus', nil, nil)
    total_interest = basic_plan_interest + premium_plan_interest + premium_plus_plan_interest

    @interest_in_pricing_options = basic_plan_interest.to_s + ':' + premium_plan_interest.to_s + ':' + premium_plus_plan_interest.to_s
    @interest_in_pricing_options_percent = '0%:0%:0%'
    if total_interest > 0
      # Use default percentages instead of dividing by zero
      @interest_in_pricing_options_percent = (basic_plan_interest * 100 / total_interest).to_s + ':' +
                                         (premium_plan_interest * 100 / total_interest).to_s + ':' +
                                         (premium_plus_plan_interest * 100 / total_interest).to_s
    end

    # Count for each country number of visits to the landing page. Countries with no visits not included in generated data object
    country_codes_metrics = metrics.where(route: '/').where.not(country_code: [nil, '']).order(:country_code)
    country_codes_data = country_codes_metrics.group(:country_code).count
    @click_data = JSON.generate(country_codes_data)

    emptyGraph
    return unless params['start'] && params['end']

    handleGraph
  end

  # GET /metrics/new
  def new
    @metric = Metric.new
  end

  # POST /metrics or /metrics.json
  def create
    time_enter = Time.at(params['time_enter'].to_i / 1000).to_datetime
    time_exit = Time.at(params['time_exit'].to_i / 1000).to_datetime

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
