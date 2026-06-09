Rails.application.routes.draw do
  # resource :session

  get "signup", to: "registrations#new", as: :new_registration
  post "registration/create", to: "registrations#create", as: :registration
  resource :session, except: %i[ new ]
  get "login", to: "sessions#new", as: :new_session
  resources :passwords, param: :token

  # User profile

  get "users/edit", to: "users#edit", as: :edit_user_profile
  patch "users/update_profile", to: "users#update_profile", as: :update_user_profile


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "ask#searches"

  # get '/ask', to: '/divination#index'

  # resources :divination
  # resolve("Divination") { [:divination] } # needed for form with model
  root "divination#home"
  get "dashboard" => "divination#dashboard"
  # get "ask" => "divination#consult"
  post "ask" => "divination#consult"
end
