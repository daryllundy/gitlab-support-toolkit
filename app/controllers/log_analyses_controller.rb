class LogAnalysesController < ApplicationController
  before_action :set_log_file, only: [:show, :create]
  before_action :set_analysis, only: [:show, :destroy]
  
  def index
    @log_files = LogFile.includes(:analyses).recent.page(params[:page])
    @analyses = Analysis.includes(:log_file, :error_patterns).recent.page(params[:page])
  end
  
  def show
    @error_patterns = @analysis.error_patterns.includes(:analysis)
  end
  
  def create
    @analysis = @log_file.analyses.build(analysis_params)
    
    if @analysis.save
      # Enqueue background job for analysis
      LogAnalysisJob.perform_later(@analysis)
      redirect_to log_analyses_path, notice: 'Analysis started successfully.'
    else
      redirect_to log_analyses_path, alert: 'Failed to start analysis.'
    end
  end
  
  def destroy
    @analysis.destroy
    redirect_to log_analyses_path, notice: 'Analysis deleted successfully.'
  end
  
  private
  
  def set_log_file
    @log_file = LogFile.find(params[:log_file_id])
  end
  
  def set_analysis
    @analysis = Analysis.find(params[:id])
  end
  
  def analysis_params
    params.require(:analysis).permit(:analysis_type)
  end
end