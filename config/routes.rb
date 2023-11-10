Rails.application.routes.draw do
  devise_for :users,
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

  # magic link sign in 
  get 'sign_in/link', to: 'users/session_links#new', as: :new_user_session_link
  post 'sign_in/link', to: 'users/session_links#create', as: :user_session_link
  get 'sign_in/link/authenticate/:token', to: 'users/session_links#authenticate', as: :authenticate_user_session_link

  # 2FA handler
  get 'sign_in/otp', to: 'users/session_otps#new', as: :new_user_sign_in_otp
  post 'sign_in/otp', to: 'users/session_otps#create', as: :user_sign_in_otp
  
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
    resource :security, only: %i[show] do
      member do
        # 2FA
        get 'two_fa', action: :edit_two_fa
        patch 'two_fa', action: :update_two_fa
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
