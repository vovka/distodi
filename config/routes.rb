require "sidekiq/web"

Rails.application.routes.draw do
  get "/", to: redirect("/#{I18n.default_locale}")

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

  scope ":locale", locale: /#{I18n.available_locales.join("|")}/ do
    authenticate :admin_user do
      mount Sidekiq::Web => "/sidekiq"
    end
    ActiveAdmin.routes(self) rescue nil # when setting up the app routes are loaded before DB schema and ActiveAdmin can't establish connection

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

    resources :leads, only: %i( new create )
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
        get :show_pdf
      end
      resources :services do
        member do
          patch :approve
          patch :decline
        end
      end
    end

    # TODO: remove this routes, must use that one services rousource inside the items
    resources :services do
      member do
        patch :approve
        patch :decline
      end
    end

    resources :checkouts, only: %i( show new create )

    get           "/dashboard" => "items#dashboard",          as: :dashboard
    get           "/dashboard" => "items#dashboard",          as: :home
    get         "/item/:token" => "items#show_for_company",   as: :show_for_company
    get "/item/service/:token" => "services#company_service", as: :company_service
    get           "/addresses" => "addresses#search"
    get               "/about" => "static_pages#about",       as: :static_pages_about
    get            "/security" => "static_pages#security",    as: :static_pages_security
    get         "/tutorialcar" => "static_pages#tutorialcar", as: :static_pages_tutorialcar
    get             "/careers" => "static_pages#careers",     as: :static_pages_careers
    get                "/lead" => "static_pages#lead",        as: :static_pages_lead
    get               "/terms" => "static_pages#terms",       as: :static_pages_terms
    get                 "/new" => "static_pages#home",        as: :static_pages_home
    get            "/donation" => "checkouts#new",            as: :donation

    post "/notifications/:id/read" => "notifications#read", constraints: ->(request) { request.xhr? }

    authenticated :user do
      root "items#dashboard", as: :authenticated_root
      get "/profile" => "users#profile"
    end

    authenticated :company do
      root "items#dashboard_company", as: :authenticated_root_company
      get "/profile" => "companies#profile"
    end
    # Temporary changed root route
    if ENV["HOME_PAGE_TRIGGER"].present?
      root "static_pages#home"
    else
      root "leads#new"
    end

    resources :blockchain_infos, path: "blockchain", param: "hash"
  end

  get "*path",
    constraints: lambda { |req| !req.path.starts_with? "/#{I18n.default_locale}/" },
    to: redirect do |params, request|
      "#{request.protocol}#{request.host_with_port}/#{I18n.default_locale}/#{params[:path]}?#{request.params.to_query}"
    end

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
