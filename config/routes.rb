Rails.application.routes.draw do
  root 'pages#home', :as => :home

  #get 'pages/about'

  resources :profiles

  devise_for :users, :controllers => { :registrations => 'registrations' }

  get 'search/' => 'search#search', :as => :search
  get 'search/:query' => 'search#search'

  get 'watchlist' => 'lst#show'
  get 'series/:id' => 'series#show', :as => :series
  get 'series/:series_id/episode/:ep_id' => 'episode#show'

  scope '/api' do
    scope '/v1', defaults: {format: :json} do
      get 'search/' => 'search#search'
      get 'search/:query' => 'search#search'
      get 'key' => 'lst#key'
      get 'user/:id/watchlist' => 'lst#show'
      post 'user/:id/watchlist' => 'lst#addToWatchlist'
      delete 'user/:id/watchlist' => 'lst#removeFromWatchlist'
      get 'series/:id' => 'series#show'
      get 'series/:series_id/episode/:ep_id' => 'episode#show'
      post 'series/:series_id/episode/:ep_id' => 'episode#addWatched'
      delete 'series/:series_id/episode/:ep_id' => 'episode#removeWatched'
    end
  end
end
