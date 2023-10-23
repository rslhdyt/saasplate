Rails.application.routes.draw do
  devise_for :users,
  controllers: {
    registrations: 'users/registrations'
  },
  path: '',
  path_names: {
    sign_in: 'sign_in',
    sign_up: 'sign_up',
    sign_out: 'sign_out'
  }
  
  resource :active_company, only: %i[update]
  resources :companies
  
  namespace :users do
    resources :invitations do
      collection do
        get :accept
      end
      
      member do
        post :resend
      end
    end
  end
  
  resources :users, except: %i[new create]
  resource :profile, only: %i[show edit update]

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "dashboard#index"
end
