require 'csv'

module FoodMenu
  class GenerateCsv < ApplicationService
    attr_reader :user

    def initialize(user)
      @user = user
    end

    def call
      csv_data = generate_csv_data
      save_csv_to_file(csv_data)
    end

    private

    def generate_csv_data
      CSV.generate(headers: true) do |csv|
        csv << csv_headers

        user.food_menu_items.each do |food_menu_item|
          csv << csv_row(food_menu_item)
        end
      end
    end

    def csv_headers
      %w[dish_name dish_description category allergens dish_type price]
    end

    def csv_row(food_menu_item)
      [
        food_menu_item.dish_name,
        food_menu_item.dish_description,
        food_menu_item.category,
        food_menu_item.allergens,
        food_menu_item.dish_type,
        food_menu_item.price
      ]
    end

    def save_csv_to_file(csv_data)
      file_name = "food_menu_items_#{Time.now.strftime('%Y%m%d%H%M%S')}.csv"
      file_path = Rails.root.join('tmp', file_name)

      File.open(file_path, 'wb') do |file|
        file.write(csv_data)
      end

      file_path
    end
  end
end
