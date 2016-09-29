Rails.application.routes.draw do
  root 'welcome#index'

  #get '/new', to: 'users#new'
  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
  #get '/login', to: 'users#login'
  #get '/logout', to: 'users#logout'
  resources :users #, except: [:new, :create]

  get '/home', to: 'static_pages#home'
  get '/help', to: 'static_pages#help'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
