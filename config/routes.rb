Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  namespace :v1 do
    resources :competitions, only: [:show] do
      resources :leagues, only: [:index, :create]
    end
    resources :matches, only: [] do
      resources :predictions, only: [:create]
    end
    resources :leagues, only: [:destroy] do
      resources :memberships, only: [:create]
    end
    resources :matches, only: [:index]
    resources :predictions, only: [:update]
    resources :memberships, only: [:destroy]
    resources :users, only: [:show]
  end
end
