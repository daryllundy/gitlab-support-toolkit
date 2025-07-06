class LogAnalysisJob < ApplicationJob
  queue_as :default

  def perform(analysis)
    log_file = analysis.log_file
    parsing_service = LogParsingService.new(log_file)
    
    begin
      parsing_service.parse(analysis.analysis_type)
      log_file.update!(status: 'completed') if log_file.pending?
    rescue => e
      Rails.logger.error "Log analysis failed for analysis #{analysis.id}: #{e.message}"
      analysis.update!(
        status: 'failed',
        result_summary: "Analysis failed: #{e.message}",
        completed_at: Time.current
      )
      log_file.update!(status: 'failed')
    end
  end
end