Rails.application.routes.draw do
  root 'pages#home', :as => :home

  #get 'pages/about'

  resources :profiles

  devise_for :users, :controllers => { :registrations => 'registrations' }

  get 'search/' => 'search#search', :as => :search
  get 'search/:query' => 'search#search'

  scope '/api' do
    scope '/v1' do
      get 'user/:id/watchlist' => 'lst#show'
      post 'user/:id/watchlist' => 'lst#addToWatchList'
    end
  end
end
