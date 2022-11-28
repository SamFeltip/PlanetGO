class MetricsController < ApplicationController
  before_action :set_metric, only: %i[ show edit update destroy ]

  # GET /metrics or /metrics.json
  def index
    def getCommonMetrics(metrics, numMetrics)

      numberOfVisits = numMetrics.to_s
      numberOfInteractionsPerVisit = "N/a"
      if numMetrics > 0
        numberOfInteractionsPerVisit = (metrics.sum(:number_interactions)/numMetrics).to_s
      end

      # Average time spent on page in h:m:s format. If more than 24 hours, instead return string "More than a day" 
      averageTimeSpent = 0
      metrics.pluck(:time_enter).lazy.zip(metrics.pluck(:time_exit)).each do |enterTime, exitTime|
        averageTimeSpent += ((exitTime - enterTime)/numMetrics)
      end
      if averageTimeSpent > 86400
        averageTimeSpent = "More than a day"
      else
        averageTimeSpent = "%02d:%02d:%02d" % [averageTimeSpent / 3600, averageTimeSpent / 60 % 60, averageTimeSpent % 60]
      end


      return [
        ["# visits", numberOfVisits],
        ["x̄ # interactions/visit", numberOfInteractionsPerVisit],
        ["x̄ time spent on page", averageTimeSpent],
      ]
    end

    @metrics = Metric.all
    routesInterestedIn = ["/", "/metrics", 
      "/reviews", "/reviews/#", "/reviews/new", "/reviews/#/edit", 
      "/users", "/users/#", "/users/new", "/users/#/edit"]

    # lists all routes of application. Way too many to display metrics for. Need to specify pages manually
    # p Rails.application.routes.routes.map { |r| {alias: r.name, path: r.path.spec.to_s, controller: r.defaults[:controller], action: r.defaults[:action]}}
    
    @allMetrics = []
    routesInterestedIn.each do |route|
      metricsList = @metrics.where(route: route)
      numMetrics = metricsList.count()
      @allMetrics.append({ "route" => route, "metrics" => getCommonMetrics(metricsList, numMetrics)})
    end

    @numberLandingPageVisits = @metrics.where(route: "/").count().to_s
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
