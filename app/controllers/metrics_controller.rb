class MetricsController < ApplicationController
  before_action :set_metric, only: %i[ show edit update destroy ]

  # GET /metrics or /metrics.json
  def index
    @metrics = Metric.all
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
