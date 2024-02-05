class CsvImportTrackerController < ApplicationController
  before_action :authenticate_user!

  def index
    if current_user.nil?
      render json: { error: 'No user is currently logged in. Please log in to perform this action.' }, status: :unprocessable_entity
    else
      render json: current_user.csv_import_tracker.order(created_at: :desc)
    end
  end
end
