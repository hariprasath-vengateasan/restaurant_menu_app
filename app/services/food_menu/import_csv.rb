require 'csv'

module FoodMenu
  class ImportCsv < ApplicationService
    attr_reader :user, :csv_file_path, :csv_import_tracker_id
    attr_accessor :csv_import_tracker

    def initialize(user, csv_file_path, csv_import_tracker_id)
      @user = user
      @csv_file_path = csv_file_path
      @csv_import_tracker_id = csv_import_tracker_id
      @issues = []
      @error_messages = []
      @csv_import_tracker = get_csv_import_tracker
    end

    def call
      process_data
      update_error_message
    end

    private

    def process_data
      CSV.foreach(csv_file_path, headers: true) do |row|
        @issues = []
        food_menu_params = row.to_h.deep_symbolize_keys.slice(:dish_name, :dish_description, :dish_type, :allergens, :category, :price)
        validate_food_menu_params(food_menu_params)

        next if @issues.any? && (@error_messages += @issues)

        food_menu_params[:dish_name] = format_string(food_menu_params[:dish_name])

        if existing_food_menu = find_existing_food_menu(food_menu_params[:dish_name])
          update_food_menu(existing_food_menu, food_menu_params)
        else
          create_food_menu(food_menu_params)
        end
      end
      csv_import_tracker.update(status: 'Completed') if @error_messages.empty?
    rescue => e
      handle_exception(e)
    end

    def format_string(value)
      value.to_s.strip.downcase
    end

    def find_existing_food_menu(dish_name)
      user.food_menu_items.find_by(dish_name: dish_name)
    end

    def update_food_menu(existing_food_menu, food_menu_params)
      updates = {
        dish_description: format_string(food_menu_params[:dish_description]),
        category: format_string(food_menu_params[:category]),
        allergens: format_string(food_menu_params[:allergens]),
        dish_type: format_string(food_menu_params[:dish_type]),
        price: food_menu_params[:price]
      }
      existing_food_menu.update(updates)
    end

    def create_food_menu(food_menu_params)
      food_menu = user.food_menu_items.new(food_menu_params)
      unless food_menu.save
        handle_food_menu_save_error(food_menu)
      end
    end

    def validate_food_menu_params(params)
      validate_presence(params, :dish_name)
      validate_string(params, :dish_type)
      validate_string(params, :dish_description, required: false)
      validate_string(params, :allergens, required: false)
      validate_presence(params, :category)
      validate_price(params)
    end

    def validate_presence(params, field)
      return if params[field].present?

      @issues << {
        base: "field_error #{field}",
        error: "#{field.to_s.humanize} can't be blank"
      }
    end

    def validate_string(params, field, options = {})
      return unless params[field].present?
      return if params[field].is_a?(String)

      @issues << {
        base: "field_error #{field}",
        error: "#{field.to_s.humanize} should be a string"
      }

      if options[:required] && params[field].blank?
        @issues << {
          base: "field_error #{field}",
          error: "#{field.to_s.humanize} can't be blank"
        }
      end
    end

    def validate_price(params)
      if params[:price].blank? || !params[:price].match?(/\A\d+(\.\d+)?\z/)
        @issues << {
          base: "field_error price",
          error: "#{params[:dish_name].humanize}'s price should be a non-blank float or integer value"
        }
      end
    end

    def handle_food_menu_save_error(food_menu)
      csv_import_tracker.update(status: 'Failed', error_messages: food_menu.errors.full_messages)
      @error_messages << {
        base: "Record Adding error",
        error: food_menu.errors.full_messages.join(', ')
      }
    end

    def handle_exception(exception)
      @error_messages << {
        base: "CSV Error",
        error: exception.message
      }
    end

    def get_csv_import_tracker
      CsvImportTracker.find(csv_import_tracker_id)
    end

    def update_error_message
      csv_import_tracker.update(status: 'Failed', error_messages: @error_messages) unless @error_messages.blank?
    end
  end
end
