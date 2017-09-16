Myflix::Application.routes.draw do
  root to: 'pages#front'
  resources :videos, only: [:show] do
    collection do
      get '/search', to: 'videos#search'
    end
  end
  get 'ui(/:action)', controller: 'ui'
  get 'register', to: 'users#new'
  get 'genre/:id', to: 'categories#show'
  resources :users, only: [:create]
end
