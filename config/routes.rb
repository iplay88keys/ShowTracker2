Rails.application.routes.draw do
  root 'pages#home', :as => :home

  #get 'pages/about'

  resources :profiles

  devise_for :users, :controllers => { :registrations => 'registrations' }

  get 'search/' => 'search#search', :as => :search
  get 'search/:query' => 'search#search'

  get 'watchlist' => 'lst#show'

  scope '/api' do
    scope '/v1', defaults: {format: :json} do
      get 'key' => 'lst#key'
      get 'user/:id/watchlist' => 'lst#show'
      post 'user/:id/watchlist' => 'lst#addToWatchlist'
      post 'user/:id/watchlist' => 'lst#removeFromWatchlist'
    end
  end
end
