class Analysis < ApplicationRecord
  belongs_to :log_file
  has_many :error_patterns, dependent: :destroy
  
  validates :result_summary, presence: true
  validates :analysis_type, presence: true
  
  enum status: { pending: 0, running: 1, completed: 2, failed: 3 }
  enum analysis_type: { 
    error_detection: 0, 
    performance_analysis: 1, 
    security_scan: 2, 
    custom_pattern: 3 
  }
  
  scope :recent, -> { order(created_at: :desc) }
  scope :by_type, ->(type) { where(analysis_type: type) }
end