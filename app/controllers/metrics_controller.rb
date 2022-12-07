class MetricsController < ApplicationController
  include DBQueries
  before_action :set_metric, only: %i[ show edit update destroy ]

  # GET /metrics or /metrics.json
  def index
    def handleGraph()
      startDateArray = params["start"].split("-")
      endDateArray = params["end"].split("-")

      # Workout start end Time objects. Default is one month ago and now respectively
      startDateTimeStamp = Time.now - 1.month
      endDateTimeStamp = Time.now
      if startDateArray.length() == 3
        startDateTimeStamp = Time.new(startDateArray[0],startDateArray[1],startDateArray[2])
      end
      if endDateArray.length() == 3
        endDateTimeStamp = Time.new(endDateArray[0],endDateArray[1],endDateArray[2])
      end

      # Get date increment from params. Default is one day if no param passed
      dateIncrement = 1.day
      if params["resolution"] == "Month"
        dateIncrement = 1.month
      elsif params["resolution"] == "Year"
        dateIncrement = 1.year
      end

      registerInterests = RegisterInterest.all
      metrics = Metric.where(route: "/")
      if params["page"]
        metrics = Metric.where(route: params["page"])
      end

      @data_keys = []
      @data_values = []

      # TODO: Is there a way to make this more DRY?
      case params["metric"]
      when "# visits", "Total number of landing page visits"
        data = []
        while startDateTimeStamp < endDateTimeStamp
          @data_keys.append(startDateTimeStamp.strftime("%F"))
          data.append(getNumberOfVisits(metrics, startDateTimeStamp, startDateTimeStamp + dateIncrement))
          startDateTimeStamp += dateIncrement
        end

        @data_values = JSON.generate([{label: "# visits", data: data}])
      when "x̄ # clicks/visit"
        data= []
        while startDateTimeStamp < endDateTimeStamp
          @data_keys.append(startDateTimeStamp.strftime("%F"))
          data.append(getNumberOfInteractionsPerVisit(metrics, startDateTimeStamp, startDateTimeStamp + dateIncrement))
          startDateTimeStamp += dateIncrement
        end

        @data_values = JSON.generate([{label: "x̄ # clicks/visit", data: data}])
      when "x̄ time on page"
        data = []
        while startDateTimeStamp < endDateTimeStamp
          @data_keys.append(startDateTimeStamp.strftime("%F"))
          data.append(getAverageTimeSpent(metrics, startDateTimeStamp, startDateTimeStamp + dateIncrement))
          startDateTimeStamp += dateIncrement
        end

        @data_values = JSON.generate([{label: "x̄ time on page", data: data}])
      when "Pricing page bounce outs"
        data = []
        while startDateTimeStamp < endDateTimeStamp
          @data_keys.append(startDateTimeStamp.strftime("%F"))
          data.append(getNumberPricingPageBounceOuts(metrics, registerInterests, startDateTimeStamp, startDateTimeStamp + dateIncrement))
          startDateTimeStamp += dateIncrement
        end

        @data_values = JSON.generate([{label: "Pricing page bounce outs", data: data}])
      when "Interest in pricing options Basic:Premium:Premium+ Total"
        pricing_interest = RegisterInterest.all()
        basic = []
        premium = []
        premium_plus = []
        while startDateTimeStamp < endDateTimeStamp
          @data_keys.append(startDateTimeStamp.strftime("%F"))
          basic.append(getPricingInterest(pricing_interest, "basic", startDateTimeStamp, startDateTimeStamp + dateIncrement))
          premium.append(getPricingInterest(pricing_interest, "premium", startDateTimeStamp, startDateTimeStamp + dateIncrement))
          premium_plus.append(getPricingInterest(pricing_interest, "premium_plus", startDateTimeStamp, startDateTimeStamp + dateIncrement))
          startDateTimeStamp += dateIncrement
        end
        @data_values = JSON.generate([{label: "Basic", data: basic}, {label: "Premium", data: premium}, {label: "Premium+", data: premium_plus}])
      when "Interest in pricing options Basic:Premium:Premium+ Percent"
        pricing_interest = RegisterInterest.all()
        basic = []
        premium = []
        premium_plus = []
        while startDateTimeStamp < endDateTimeStamp
          @data_keys.append(startDateTimeStamp.strftime("%F"))
          basicValue = getPricingInterest(pricing_interest, "basic", startDateTimeStamp, startDateTimeStamp + dateIncrement)
          premiumValue = getPricingInterest(pricing_interest, "premium", startDateTimeStamp, startDateTimeStamp + dateIncrement)
          premiumPlusValue = getPricingInterest(pricing_interest, "premium_plus", startDateTimeStamp, startDateTimeStamp + dateIncrement)
          total = basicValue+premiumValue+premiumPlusValue
          if total == 0
            total = 1
          end
          
          basic.append((basicValue*100)/total) 
          premium.append((premiumValue*100)/total) 
          premium_plus.append((premiumPlusValue*100)/total)

          startDateTimeStamp += dateIncrement
        end
        @data_values = JSON.generate([{label: "Basic", data: basic}, {label: "Premium", data: premium}, {label: "Premium+", data: premium_plus}])
      else
        @data_keys = [0, 1]
        @data_values = [1, 0]
      end
    end

    metrics = Metric.all
    registerInterests = RegisterInterest.all
    routesInterestedIn = ["/", "/metrics", 
      "/reviews", "/reviews/#", "/reviews/new", "/reviews/#/edit", 
      "/users", "/users/#", "/users/new", "/users/#/edit"]

    # lists all routes of application. Way too many to display metrics for. Need to specify pages manually
    # p Rails.application.routes.routes.map { |r| {alias: r.name, path: r.path.spec.to_s, controller: r.defaults[:controller], action: r.defaults[:action]}}
    
    @allMetrics = []
    routesInterestedIn.each do |route|
      metricsList = metrics.where(route: route)
      numMetrics = metricsList.count()
      @allMetrics.append({ "route" => route, "metrics" => getCommonMetrics(metricsList, numMetrics)})
    end

    @numberLandingPageVisits = metrics.where(route: "/").count().to_s
    @numberPricingPageBounceOuts = getNumberPricingPageBounceOuts(metrics, registerInterests, nil, nil).to_s

    # Calculates the two Interests metrics
    basicPlanInterest = getPricingInterest(registerInterests, "basic", nil, nil)
    premiumPlanInterest = getPricingInterest(registerInterests, "premium", nil, nil)
    premiumPlusPlanInterest = getPricingInterest(registerInterests, "premium_plus", nil, nil)
    totalInterest = basicPlanInterest + premiumPlanInterest + premiumPlusPlanInterest

    @interestInPricingOptions = basicPlanInterest.to_s + ":" + premiumPlanInterest.to_s + ":" + premiumPlusPlanInterest.to_s
    @interestInPricingOptionsPercent = "0%:0%:0%"
    if totalInterest > 0
      @interestInPricingOptionsPercent = (basicPlanInterest*100/totalInterest).to_s + ":" + 
        (premiumPlanInterest*100/totalInterest).to_s + ":" + 
        (premiumPlusPlanInterest*100/totalInterest).to_s
    end

    countryCodesMetrics = metrics.where.not(country_code: [nil, ""]).order(:country_code)
    countryCodesData = countryCodesMetrics.group(:country_code).count
    @clickData = JSON.generate(countryCodesData)
    @clickData = JSON.generate({"GBR":75})

    if params["start"] && params["end"]
      handleGraph()
    end
  end

  # GET /metrics/1 or /metrics/1.json
  def show
  end

  # GET /metrics/new
  def new
    @metric = Metric.new
  end

  # GET /metrics/1/edit
  def edit
  end

  # POST /metrics or /metrics.json
  def create
    time_enter = Time.at(params["time_enter"].to_i / 1000).to_datetime
    time_exit = Time.at(params["time_exit"].to_i / 1000).to_datetime
    
    Metric.create(
      time_enter:         time_enter,
      time_exit:          time_exit,
      route:              params['route'],
      latitude:           params['latitude'],
      longitude:          params['longitude'],
      country_code:       params['country_code'],
      is_logged_in:       params['is_logged_in'],
      number_interactions:params['number_interactions'],
      pricing_selected:   params['pricing_selected']
    )
    
    head :ok
  end

  # PATCH/PUT /metrics/1 or /metrics/1.json
  def update
    respond_to do |format|
      if @metric.update(metric_params)
        format.html { redirect_to metric_url(@metric), notice: "Metric was successfully updated." }
        format.json { render :show, status: :ok, location: @metric }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @metric.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /metrics/1 or /metrics/1.json
  def destroy
    @metric.destroy

    respond_to do |format|
      format.html { redirect_to metrics_url, notice: "Metric was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_metric
      @metric = Metric.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def metric_params
      params.require(:metric).permit(:time_enter, :time_exit, :route, :lattitude, :longitude, :is_logged_in, :number_interactions, :pricing_selected)
    end
end
