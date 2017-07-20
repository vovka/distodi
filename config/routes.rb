Rails.application.routes.draw do
  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config
  devise_for :companies, controllers: {
    registrations: "companies/registrations",
    sessions: "companies/sessions",
    passwords: "companies/passwords"
  }
  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions",
    passwords: "users/passwords",
    omniauth_callbacks: "users/omniauth_callbacks"
  }

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

  get :dashboard, to: "items#index", as: :dashboard
  get :dashboard, to: "items#index", as: :home
  get "item/:token", to: "items#show_for_company", as: :show_for_company
  get "item/service/:token", to: "services#company_service", as: :company_service
  get "static_pages/home"
  get "static_pages/about"
  get "static_pages/tutorial"
  get "static_pages/tutorialcar"
  get "static_pages/tutorialbike"

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
