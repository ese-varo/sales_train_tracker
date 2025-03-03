Rails.application.routes.draw do
  # Authentication
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'login', to: 'sessions#destroy'

  # Sales and tickets
  resources :sales do
    member do
      post 'print_ticket'
    end
  end

  # Locations with nexted printer configurations
  resources :locations do
    resources :printer_configs do
      member do
        post 'test_print'
      end
    end
  end

  # User management
  resources :users

  # Reports
  resources :reports, only: [:index] do
    collection do
      get 'daily'
      get 'monthly'
      get 'export'
    end
  end

  # Root path based on user role
  constraints UserRoleConstraint::Cashier do
    root to: 'sales#new', as: :cashier_root
  end

  constraints UserRoleConstraint::Manager do
    root to: 'reports#daily', as: :manager_root
  end

  # Default root path
  root to: 'sessions#new'

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
