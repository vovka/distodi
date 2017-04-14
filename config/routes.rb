Rails.application.routes.draw do

  resources :leads
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  resources :attribute_kinds

  get 'static_pages/home', as: 'home'

  get 'static_pages/about'
  get 'static_pages/tutorial', as: 'tutorial'
  get 'static_pages/tutorialcar', as: 'tutorialcar'
  get 'static_pages/tutorialbike', as: 'tutorialbike'

  devise_for :companies, controllers: { registrations: 'companies/registrations', sessions: 'companies/sessions' }
  devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions' }

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
    end
  end

  get 'item/:token', to: "items#show_for_company", as: 'show_for_company'
  get 'item/service/:token', to: "services#company_service", as: 'company_service'

  resources :items do
    collection do
      get 'get_attributes', to: "items#get_attributes"
    end
  end

  resources :services do
    member do
      patch 'approve', as: "approve"
      patch 'decline', as: "decline"
    end
  end

  resources :service_kinds
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'static_pages#home'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
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
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
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
