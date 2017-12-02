require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :admin_user do
    mount Sidekiq::Web => '/sidekiq'
  end
  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config
  devise_for :companies, controllers: {
    registrations: "companies/registrations",
    sessions: "companies/sessions",
    passwords: "companies/passwords",
  }
  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions",
    passwords: "users/passwords",
  }

  %w(facebook twitter google linkedin).each do |provider|
    devise_scope :user do
      get "/users/auth/:provider" => "omniauth_callbacks#passthru", defaults: { provider: provider, resource: "users" }, as: :"user_#{provider}_omniauth_authorize"
      get "/auth/#{provider}/callback" => "omniauth_callbacks#default_callback", defaults: { provider: provider }
    end

    devise_scope :company do
      get "/companies/auth/:provider", to: "omniauth_callbacks#passthru", defaults: { provider: provider, resource: "companies" }, as: :"company_#{provider}_omniauth_authorize"
      get "/auth/#{provider}/callback" => "omniauth_callbacks#default_callback", defaults: { provider: provider }
    end
  end

  devise_scope :user do
    get "/users/passwords/reset_success" => "users/passwords#reset_success"
    get "/users/passwords/new_pass_success" => "users/passwords#new_pass_success"
    get "/users/registrations/success" => "users/registrations#success"
  end

  devise_scope :company do
    get "/companies/passwords/reset_success" => "companies/passwords#reset_success"
    get "/companies/passwords/new_pass_success" => "companies/passwords#new_pass_success"
    get "/companies/registrations/success" => "companies/registrations#success"
  end

  resources :leads
  resources :attribute_kinds
  resources :service_kinds

  resources :users do
    member do
      get :services
      get :companies
    end
  end

  resources :companies do
    member do
      get :items
      get :services
      get :activate
    end
  end

  resources :items do
    collection do
      get :get_attributes
    end
    member do
      post :transfer
      post :receive
    end
  end

  resources :services do
    member do
      patch :approve
      patch :decline
    end
  end

  resources :checkouts, only: %i( show new create )

  get :dashboard, to: "items#dashboard", as: :dashboard
  get :dashboard, to: "items#dashboard", as: :home
  get "item/:token", to: "items#show_for_company", as: :show_for_company
  get "item/service/:token", to: "services#company_service", as: :company_service
  get "profile", to: "users#profile"

  get       "about" => "static_pages#about",       as: :static_pages_about
  get    "security" => "static_pages#security",    as: :static_pages_security
  get "tutorialcar" => "static_pages#tutorialcar", as: :static_pages_tutorialcar
  get     "careers" => "static_pages#careers",     as: :static_pages_careers
  get        "lead" => "static_pages#lead",        as: :static_pages_lead
  get       "terms" => "static_pages#terms",       as: :static_pages_terms

  post 'notifications/:id/read', to: "notifications#read", constraints: ->(request) { request.xhr? }

  root "static_pages#home"

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # Example of regular route:
  #   get "products/:id" => "catalog#view"

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get "products/:id/purchase" => "catalog#purchase", as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get "short"
  #       post "toggle"
  #     end
  #
  #     collection do
  #       get "sold"
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get "recent", on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post "toggle"
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
