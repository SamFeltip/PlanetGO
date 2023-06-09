# frozen_string_literal: true

class BugReportsController < ApplicationController
  before_action :set_bug_report, only: %i[show edit update destroy]
  before_action :authenticate_user!
  load_and_authorize_resource

  # GET /bug_reports or /bug_reports.json
  def index
    @bug_reports = if current_user.admin?
                     BugReport.all.includes([:user])
                   else
                     BugReport.where(user: current_user).includes([:user])
                   end

    return if params[:search].blank?

    @query = params[:search][:query]
    @category = params[:search][:category]
    @bug_reports = @bug_reports.search(@query) if @query.present?
    @bug_reports = @bug_reports.by_category(@category) if @category.present? && @category != 'filter categories...'
  end

  # GET /bug_reports/1 or /bug_reports/1.json
  def show; end

  # GET /bug_reports/new
  def new
    @bug_report = BugReport.new
  end

  # GET /bug_reports/1/edit
  def edit; end

  # POST /bug_reports or /bug_reports.json
  def create
    @bug_report = BugReport.new(bug_report_params)
    @bug_report.user_id = current_user.id

    respond_to do |format|
      if @bug_report.save
        format.html { redirect_to bug_report_url(@bug_report), notice: 'Bug report was successfully created.' }
        format.json { render :show, status: :created, location: @bug_report }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @bug_report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bug_reports/1 or /bug_reports/1.json
  def update
    respond_to do |format|
      if @bug_report.update(bug_report_params)
        format.html { redirect_to bug_report_url(@bug_report), notice: 'Bug report was successfully updated.' }
        format.json { render :show, status: :ok, location: @bug_report }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @bug_report.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bug_reports/1 or /bug_reports/1.json
  def destroy
    @bug_report.destroy

    respond_to do |format|
      format.html { redirect_to bug_reports_url, notice: 'Bug report was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_bug_report
    @bug_report = BugReport.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def bug_report_params
    params.require(:bug_report).permit(:title, :description, :category, :resolved, :user_id, :evidence)
  end
end
