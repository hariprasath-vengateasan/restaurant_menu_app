class CsvImportTracker < ApplicationRecord
  belongs_to :user

  validates :status, presence: true
  validate :valid_status

  private

  def valid_status
    errors.add(:status, 'must be one of In Progress, Completed, or Failed') unless ['In Progress','Completed','Failed'].include?(status)
  end
end