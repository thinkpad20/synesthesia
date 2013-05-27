App::Application.routes.draw do
  resources :likes


  resources :sounds


  resources :images


  resources :users

  get "/home", :controller => "home", :action => "hero", as: "home"

  get '/sessions/new' => 'Sessions#new', as: 'new_session'
  post '/sessions' => 'Sessions#create', as: 'log_in'
  delete '/sessions' => 'Sessions#destroy', as: 'log_out'

end
