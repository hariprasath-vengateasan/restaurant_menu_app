class FoodMenuItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :get_food_menu_items, only: [:update, :destroy]

  def index
    if current_user.nil?
      render json: { error: 'No user is currently logged in. Please log in to perform this action.' }, status: :unprocessable_entity
    else
      render json: current_user.food_menu_items
    end
  end

  def create
    @food_menu_item = current_user.food_menu_items.new(food_menu_params)
    if @food_menu_item.save
      render json: @food_menu_item, status: :created
    else
      render json: { errors: @food_menu_item.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if authorized_user?
      if @food_menu_item.update(food_menu_params)
        render json: @food_menu_item
      else
        render json: { errors: @food_menu_item.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Unauthorized access' }, status: :unauthorized
    end
  end

  def destroy
    if authorized_user?
      @food_menu_item.destroy
      render json: { message: 'Food menu deleted successfully' }
    else
      render json: { error: 'Unauthorized access' }, status: :unauthorized
    end
  end

  def import_csv
    if current_user.nil?
      render json: { error: 'No user is currently logged in. Please log in to perform this action.' }, status: :unprocessable_entity
    else
      csv_temp_file_path = create_temp_file(params)
      csv_import_tracker = CsvImportTracker.new(user: current_user, status: 'In Progress')
      if csv_import_tracker.save!
        job = FoodMenu::ImportCsv.delay.call(current_user, csv_temp_file_path, csv_import_tracker.id)
        csv_import_tracker.update(delayed_job_id: job.id)
        render json: { csv_import_tracker_id: csv_import_tracker.id, message: 'CSV import started' }
      else
        render json: { errors: csv_import_tracker.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end

  def generate_csv_data
    if current_user.nil?
      render json: { error: 'No user is currently logged in. Please log in to perform this action.' }, status: :unprocessable_entity
    else
      csv_file_path = FoodMenu::GenerateCsv.call(current_user)
      send_file(csv_file_path, type: 'text/csv', filename: 'food_menu_items.csv')
    end
  end

  private

  def get_food_menu_items
    @food_menu_item = FoodMenuItem.find(params[:id])
  end

  def food_menu_params
    params.require(:food_menu_item).permit(:name, :description, :price, :category, :allergens)
  end

  def authorized_user?
    @food_menu_item.user == current_user
  end

  def create_temp_file(params)
    # Assuming you have the CSV file in params
    csv_file = params[:csv_file]

    # Generate a unique file name
    unique_filename = "#{SecureRandom.uuid}.csv"
    FileUtils.mv(csv_file.tempfile.path, File.join(TEMPORARY_DIRECTORY, unique_filename))
    
    File.join(TEMPORARY_DIRECTORY, unique_filename)
  end
end
