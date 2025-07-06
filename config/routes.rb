Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Root route
  root "dashboard#index"
  
  # Dashboard
  get "dashboard", to: "dashboard#index"
  
  # Log Analysis
  resources :log_analyses, only: [:index, :show, :destroy]
  resources :log_files do
    resources :analyses, controller: 'log_analyses', only: [:create]
  end
  
  # API Testing
  resources :api_tests, only: [:index, :create] do
    collection do
      delete :clear_results
    end
  end
end