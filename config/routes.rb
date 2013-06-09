App::Application.routes.draw do
  resources :relationships


  resources :comments


  resources :likes
  resources :likes do
    member do
      get 'toggle_like'
    end
  end


  resources :sounds


  resources :images


  resources :users

  get "/", :controller => "home", :action => "hero", as: "root"
  get "/home", :controller => "home", :action => "hero", as: "home"

  get '/sessions/new' => 'Sessions#new', as: 'new_session'
  post '/sessions' => 'Sessions#create', as: 'log_in'
  delete '/sessions' => 'Sessions#destroy', as: 'log_out'

end
