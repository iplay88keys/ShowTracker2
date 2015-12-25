require 'api_constraints'

Rails.application.routes.draw do
  root 'pages#home', :as => :home

  #get 'pages/about'

  resources :profiles, :except => :index

  get 'profiles/:user_id/generate_key' => 'profiles#generate_key', :as =>:generate


  devise_for :users, :controllers => { :registrations => 'registrations' }

  get 'search/' => 'search#search', :as => :search
  get 'search/:query' => 'search#search'
  
  get 'watchlist' => 'lst#show'
  post 'watchlist' => 'lst#addToWatchlist'
  delete 'watchlist' => 'lst#removeFromWatchlist'
  get 'series/:series_id' => 'series#show', :as => :series
  post 'series/:series_id' => 'series#addAllWatched'
  delete 'series/:series_id' => 'series#removeAllWatched'
  get 'series/:series_id/season/all' => 'season#all', :as => :season_all
  get 'series/:series_id/season/:season_id' => 'season#show', :as => :season
  get 'series/:series_id/episode/:ep_id' => 'episode#show', :as => :episode
  post 'series/:series_id/episode/:ep_id' => 'episode#addWatched'
  delete 'series/:series_id/episode/:ep_id' => 'episode#removeWatched'

  namespace :api, defaults: {format: 'json'} do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      get 'search/:query' => 'search#search'
      get 'searchremote/:query' => 'search#searchRemote'
      get 'user/:id/watchlist' => 'lst#show'
      post 'user/:id/watchlist' => 'lst#addToWatchlist'
      delete 'user/:id/watchlist' => 'lst#removeFromWatchlist'
      get 'series/:series_id' => 'series#show'
      post 'series/:series_id' => 'series#addAllWatched'
      delete 'series/:series_id' => 'series#removeAllWatched'
      get 'series/:series_id/season/all' => 'season#all'
      get 'series/:series_id/season/:season_id' => 'season#show'
      get 'series/:series_id/episode/:ep_id' => 'episode#show'
      post 'series/:series_id/episode/:ep_id' => 'episode#addWatched'
      delete 'series/:series_id/episode/:ep_id' => 'episode#removeWatched'
    end
  end
end
