class DashboardController < ApplicationController
  def index
    @recent_log_files = LogFile.recent.limit(5)
    @recent_analyses = Analysis.recent.includes(:log_file).limit(5)
    @stats = {
      total_log_files: LogFile.count,
      total_analyses: Analysis.count,
      pending_analyses: Analysis.pending.count,
      critical_errors: ErrorPattern.critical_errors.count
    }
  end
end