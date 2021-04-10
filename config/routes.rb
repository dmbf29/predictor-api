Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  namespace :v1 do
    resources :users, only: [:show] do
      resources :matches, only: [:index]
    end
    resources :competitions, only: [:show] do
      resources :leagues, only: [:index, :create]
    end
    resources :matches, only: [] do
      resources :predictions, only: [:create]
    end
    resources :leagues, only: [:destroy] do
      resources :memberships, only: [:create]
    end
    resources :predictions, only: [:update]
    resources :memberships, only: [:destroy]
  end
end
