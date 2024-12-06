Rails.application.routes.draw do
  resources :mapa, only: :none, controller: "maps" do
    collection do
      get '' => 'maps#index', as: ""
    end
  end
  resources :data, only: :index
  resources :animitas, only: [:index, :show], controller: "places" do
    member do
      patch "approve" => "places#approve", as: "approve"
      patch "reject" => "places#reject", as: "reeject"
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  root "home#index"
end
