Rails.application.routes.draw do
  devise_for :user,
    controllers: {
      registrations: 'users/registrations',
      sessions: 'users/sessions'
    },
    path: '',
    path_names: {
      sign_in: 'sign_in',
      sign_up: 'sign_up',
      sign_out: 'sign_out'
    }

  devise_scope :user do
    get 'sign_up/companies', to: 'users/registrations#new_company', as: :new_company_registration
    post 'sign_up/companies', to: 'users/registrations#create_company', as: :company_registration
  end

  scope :sign_in, as: :user_session do
    # Login with link handler
    resource :link, only: %i[new create], controller: 'users/session_links' do
      member do
        get 'authenticate/:token', action: :authenticate, as: :authenticate
      end
    end
    # 2FA handler
    resource :otp, only: %i[new create], controller: 'users/session_otps' 
  end
  
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

  namespace :settings do
    resource :security, only: %i[show update]
    resource :two_fa, only: %i[edit update destroy]
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
