class LogFile < ApplicationRecord
  validates :name, presence: true
  validates :file_path, presence: true
  validates :file_size, presence: true, numericality: { greater_than: 0 }
  
  has_many :analyses, dependent: :destroy
  has_one_attached :file
  
  enum status: { pending: 0, processing: 1, completed: 2, failed: 3 }
  
  scope :recent, -> { order(created_at: :desc) }
end