FanzoSite::Application.routes.draw do

  resources :photos

  devise_for :admins, only: :sessions
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  authenticated :user do
    root to:'static_pages#home'
  end
  root to:'static_pages#home'

  resources :users, only: :show do
    get 'connect_twitter', on: :member
    get 'connect_instagram', on: :member
    post 'client_facebook_login', on: :collection, defaults: {format: "json"}
    resources :user_teams, only: [ :create, :destroy ] 
    resources :user_locations, only: [ :create, :destroy ]
    resources :user_brags, only: [ :create, :destroy ]
  end
  get "user_settings/edit"
  put "user_settings/update"

  resources :tailgates do
    get 'search', on: :collection
    resources :posts do
      put 'up_vote', on: :member
      put 'down_vote', on: :member
      resources :comments do
        put 'up_vote', on: :member
        put 'down_vote', on: :member
      end
    end
  end

  resources :teams do
    get :autocomplete_team_name, on: :collection
    get :bing_search_results, on: :member
  end
  
  resources :brags do
    get :autocomplete_brag_content, on: :collection
  end
  
  resources :tailgate_followers, only: [ :create, :destroy ]
  
  resources :watch_sites do
    get 'search', on: :collection
  end
  
  get 'sitemap.xml', to: "sitemap#show", as: "sitemap", defaults: { format: "xml" }
  get 'robots.txt', to: "sitemap#index", as: "robots", defaults: { format: "txt" }
  get 'about',   to: 'static_pages#about'
  get 'channel', to: 'static_pages#channel'

  post "twitter_proxy/update_status"
  post "twitter_proxy/retweet"
  post "twitter_proxy/favorite"

  get "instagram_proxy/find_tags_for_team"
  get "instagram_proxy/find_tags_for_fanzone"
  get "instagram_proxy/media_for_tag"

  resources :admins, only: :show
  resources :sports
  resources :leagues
  resources :divisions
  resources :conferences
  resources :venues
  resources :venue_types
  resources :affiliations
  resources :events
  resources :game_watches
  resources :quick_tweets
  resources :topics
  resources :people
  resources :tailgate_venues
  resources :fanzo_tips
  resources :fun_facts

  resources :athlete, path: :people
  resources :coach, path: :people
  resources :journalist, path: :people
  resources :superfan, path: :people
 
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

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
