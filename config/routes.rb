Rails.application.routes.draw do
  use_doorkeeper do
    skip_controllers :authorizations, :applications, :authorized_applications
  end
  resources :posts
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  
  get '/friends/users' => 'friends#users', as: 'users'

  get 'friends/:id' => 'friends#destroy'

  get '/friends/add/:id' => 'friends#add', as: 'add'

  get '/friends/posts/:id' => 'posts#showFriendsPost', as: 'show_friends_post'

  get '/search' => 'friends#search', as: 'search'

  get '/usersearch' => 'friends#search', as: 'friendsearch'

  get '/requests' => 'friends#requests', as: 'requests'

  get '/requests/accept/:id' => 'friends#accept', as: 'accept'

  get '/requests/decline/:id' => 'friends#decline', as: 'decline'

  get 'login/create' => 'logins#create', as: 'create_login'
  
  devise_scope :user do  
   get '/users/sign_out' => 'devise/sessions#destroy'     
  end
  resources :friends
  #get 'home/index'
  root 'friends#users'
  get 'home/about'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
