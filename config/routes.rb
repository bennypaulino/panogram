Rails.application.routes.draw do
  root 'welcome#index'

  get '/home', to: 'welcome#index'
  get '/help', to: 'static_pages#help'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'

  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  get 'password_resets/new'
  get 'password_resets/edit'

  resources :users do
    member do
      get :following, :followers, :liked_posts, :likes
    end
  end

  resources :microposts do
    member do
      get :admirers
    end
    resources :comments
  end

  resources :comments do
    resources :comments
  end

  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :microposts, only: [:create, :update, :destroy]
  resources :relationships, only: [:create, :destroy]
  resources :likes, only: [:create, :destroy]
  resources :comments, except: [:index, :show]



  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
