Rails.application.routes.draw do
  devise_for :users

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root to: 'home#index'
  mount LetterOpenerWeb::Engine, at: '/letter_opener'

  resources :food_menu_items, only: [:index, :update, :create, :destroy] do
    collection do
      get :generate_csv_data
      post :import_csv
    end
  end

  resources :csv_import_tracker, only: [:index]
end
