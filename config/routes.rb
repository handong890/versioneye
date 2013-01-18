#require_relative '../app/api/v1/versioneye'

Versioneye::Application.routes.draw do
  
  resources :swaggers


  mount V1::Versioneye::API => '/api'

  root :to => "products#index"
  
  get   '/auth/github/callback',   :to => 'github#callback'
  get   '/auth/github/new',        :to => 'github#new'
  post  '/auth/github/create',     :to => 'github#create'
  
  get   '/auth/twitter/forward',   :to => 'twitter#forward'
  get   '/auth/twitter/callback',  :to => 'twitter#callback'
  get   '/auth/twitter/new',       :to => 'twitter#new'
  post  '/auth/twitter/create',    :to => 'twitter#create'

  get   '/auth/facebook/callback', :to => 'facebook#callback'

  get   '/cloudcontrol/resources', :to => 'cloudcontrol#resources'

  
  resources :sessions, :only => [:new, :create, :destroy]
  get    '/signin',                :to => 'sessions#new'
  get    '/signout',               :to => 'sessions#destroy'
  post   '/androidregistrationid', :to => 'sessions#android_registrationid'


  get   '/users/christian.weyand',                    :to => redirect('/users/christianweyand')
  resources :users, :key => :username do
    member do 
      get 'favoritepackages'
      get 'comments'
      get 'users_location'
    end
  end
  get   '/created', :to => 'users#created'
  get   '/signup',                       :to => 'users#new'
  get   '/users/:id/notifications',      :to => 'users#notifications'
  get   '/users/activate/:verification', :to => 'users#activate'
  get   '/iforgotmypassword',            :to => 'users#iforgotmypassword'
  post  '/resetpassword',                :to => 'users#resetpassword'
  get   '/home',                         :to => 'users#home'

  get  '/settings/profile',              :to => 'settings#profile'
  get  '/settings/password',             :to => 'settings#password'
  get  '/settings/privacy',              :to => 'settings#privacy'
  get  '/settings/delete',               :to => 'settings#delete'
  get  '/settings/links',                :to => 'settings#links'
  get  '/settings/creditcard',           :to => 'settings#creditcard'
  get  '/settings/plans',                :to => 'settings#plans'
  get  '/settings/connect',              :to => 'settings#connect'
  get  '/settings/disconnect/',          :to => 'settings#disconnect'
  get  '/settings/emails/',              :to => 'settings#emails'
  get  '/settings/notifications/',       :to => 'settings#notifications'
  post '/settings/updateplan',           :to => 'settings#updateplan'
  post '/settings/delete_email',         :to => 'settings#delete_email'
  post '/settings/make_email_default',   :to => 'settings#make_email_default'
  post '/settings/add_email',            :to => 'settings#add_email'
  post '/settings/updatecreditcard',     :to => 'settings#updatecreditcard'
  post '/settings/updatepassword',       :to => 'settings#updatepassword'
  post '/settings/updateprivacy',        :to => 'settings#updateprivacy'
  post '/settings/updateprofile',        :to => 'settings#updateprofile'
  post '/settings/updatelinks',          :to => 'settings#updatelinks'
  post '/settings/updatenotifications',  :to => 'settings#updatenotifications'
  post '/settings/destroy',              :to => 'settings#destroy'

  get '/settings/api',                   :to => 'settings#api'
  post '/settings/api',                  :to => 'settings#update_api_key'

  get  '/jobs',          :to => 'jobs#index'
  
  # Legacy paths
  get   '/docs/VersionEye_NUTZUNGSBEDINGUNGEN_de_V1.0.pdf', :to => redirect("/docs/VersionEye_NUTZUNGSBEDINGUNGEN_de_V1.1.pdf")
  get   '/product/symfony--symfony',                  :to => redirect("/package/php--symfony--symfony")
  get   '/package/symfony--symfony',                  :to => redirect("/package/php--symfony--symfony")
  get   '/package/symfony--symfony/version/:version', :to => redirect('/package/php--symfony--symfony/version/%{version}')
  get   '/product/symfony--symfony/version/:version', :to => redirect('/package/php--symfony--symfony/version/%{version}')

  get   '/search',                                      :to => 'products#search'
  get   '/package/name',                                :to => 'products#autocomplete_product_name'
  post  '/package/follow',                              :to => 'products#follow'
  post  '/package/unfollow',                            :to => 'products#unfollow'
  post  '/package/image_path',                          :to => 'products#image_path'
  post  '/package/upload_image',                        :to => 'products#upload_image'
  get   '/package/:key',                                :to => 'products#show', :as => 'products'
  get   '/package/:key/edit',                           :to => 'products#edit'
  post  '/package/:key/update',                         :to => 'products#update'
  post  '/package/:key/delete_link',                    :to => 'products#delete_link'
  get   '/package/:key/version/:version',               :to => 'products#show'
  post  '/package/:key/version/:version/dependencies',  :to => 'products#recursive_dependencies'
  get   '/package/:key/version/:version/dependencies',  :to => 'products#recursive_dependencies'

  get   '/product/:key',                                :to => 'products#show'
  get   '/product/:key/version/:version',               :to => 'products#show'

  get   '/package_visual/:key/version/:version',        :to => 'products#show_visual'

  get   '/packagelike/like_overall',    :to => 'productlikes#like_overall'
  get   '/packagelike/dislike_overall', :to => 'productlikes#dislike_overall'
  get   '/packagelike/like_docu',       :to => 'productlikes#like_docu'
  get   '/packagelike/dislike_docu',    :to => 'productlikes#dislike_docu'
  get   '/packagelike/like_support',    :to => 'productlikes#like_support'
  get   '/packagelike/dislike_support', :to => 'productlikes#dislike_support'


  resources :versioncomments
  get   '/vc/:id',                       :to => 'versioncomments#show'

  resources :versioncommentreplies
  
  get '/user/projects/github_projects', :to => 'user/projects#github_projects'
  get '/user/projects/popular', :to => "user/projects#get_popular"

  namespace :user do 
    resources :projects do 
      member do
        post 'save_period'
        post 'save_email'
        post 'reparse'
        post 'update_name'
      end
    end
  end

  post  '/services/choose_plan',  :to => 'services#choose_plan'
  resources :services do
    member do
      get  'recursive_dependencies'
      post 'recursive_dependencies'
    end
  end
  get   '/pricing',            :to => 'services#pricing'
  get   '/news',               :to => 'news#news'
  get   '/mynews',             :to => 'news#mynews'
  get   '/hotnews',            :to => 'news#hotnews'

  namespace :admin do
    resources :submitted_urls do
      post '/approve',            :to => 'submitted_urls#approve'
      post '/decline',            :to => 'submitted_urls#decline'
    end
    resources :crawles
    get   '/crawles',             :to => 'crawles#index'
    get   '/group/:group',        :to => 'crawles#group', :as => 'group'
  end

  post  '/submitted_urls',      :to => 'submitted_urls#create'

  post  '/feedback',            :to => 'feedback#feedback'

  get   '/statistics',            :to => 'statistics#index'
  get   '/statistics/proglangs',  :to => 'statistics#proglangs'
  get   '/statistics/langtrends', :to => 'statistics#langtrends'


  get   '/about',               :to => 'page#about'
  get   '/impressum',           :to => 'page#impressum'
  get   '/imprint',             :to => 'page#imprint'
  get   '/nutzungsbedingungen', :to => 'page#nutzungsbedingungen'  
  get   '/terms',               :to => 'page#terms'
  get   '/datenschutz',         :to => 'page#datenschutz'
  get   '/dataprivacy',         :to => 'page#dataprivacy'
  get   '/datenerhebung',       :to => 'page#datenerhebung'
  get   '/datacollection',      :to => 'page#datacollection'
  get   '/disclaimer',          :to => 'page#disclaimer'
  get   '/apijson',             :to => 'page#apijson'  
  get   '/apijson_tools',       :to => 'page#apijson_tools'  
  get   '/apijson_libs',        :to => 'page#apijson_libs'
  get   '/newest/version',      :to => 'page#newest'
  get   '/current/version',     :to => 'page#newest'
  get   '/latest/version',      :to => 'page#newest'

  get   'sitemap_00_1.xml',        :to => 'page#sitemap_1'
  get   'sitemap_00_2.xml',        :to => 'page#sitemap_2'
  get   'sitemap_00_3.xml',        :to => 'page#sitemap_3'
  get   'sitemap_00_4.xml',        :to => 'page#sitemap_4'
  
  #default action
  get   '*path',        :to => 'page#routing_error'
  
end
