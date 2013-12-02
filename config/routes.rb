PhysiotecV3::Application.routes.draw do
  
  mount ApiExplorer::Engine => "/api_explorer"

  devise_for :users, :controllers => {:confirmations => 'confirmations'}

  devise_scope :user do
    put "/confirm" => "confirmations#confirm"
    post "/confirm" => "confirmations#confirm"
  end

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)



  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'

          
  namespace :api, :defaults => {:format => :json} do
    namespace :v1 do
      resources :licenses
      resources :scope_permissions
      resources :permissions, :except => :update
      resources :profiles do
        member do
          post 'assign_ability'
          post 'unassign_ability'
        end
      end
      resources :actions, :only => [:index, :show]

      resources :scope_groups, :except => :update do
        resources :scopes, :controller => 'scope_groups/scopes'
      end

      resources :users do
        member do
          post 'assign_profile'
          post 'unassign_profile'
          post 'assign_ability'
          post 'unassign_ability'
          get 'assignable_profiles'
        end
        resources :user_scope_permissions, :controller => 'users/user_scope_permissions', :only => [:index, :show]
        resources :user_profiles, :controller => 'users/user_profiles', :only => [:index, :show]

        collection do
          post '/login' => 'users#login'

      end          
        end
      
    end
  end

  match '*all' => 'api/v1/api#cors_access_control', :constraints => {:method => 'OPTIONS'}
end
