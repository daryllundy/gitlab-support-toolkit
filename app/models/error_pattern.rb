class ErrorPattern < ApplicationRecord
  belongs_to :analysis
  
  validates :pattern, presence: true
  validates :pattern_type, presence: true
  validates :severity, presence: true
  
  enum pattern_type: { 
    regex: 0, 
    keyword: 1, 
    multi_line: 2, 
    custom: 3 
  }
  
  enum severity: { 
    info: 0, 
    warning: 1, 
    error: 2, 
    critical: 3 
  }
  
  scope :by_severity, ->(severity) { where(severity: severity) }
  scope :by_type, ->(type) { where(pattern_type: type) }
  scope :critical_errors, -> { where(severity: :critical) }
end