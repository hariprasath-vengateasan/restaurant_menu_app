class CreateFoodMenuItems < ActiveRecord::Migration[7.1]
  def change
    create_table :food_menu_items do |t|
      t.string :dish_name
      t.text :dish_description
      t.string :dish_type
      t.string :allergens
      t.string :category
      t.decimal :price
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
