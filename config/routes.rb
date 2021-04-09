Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  namespace :v1 do
    resources :competitions, only: [] do
      resources :matches, only: [:index]
      resources :leagues, only: [:index, :create]
      resources :users, only: [:show]
      resources :memberships, only: [:create]
    end
    resources :matches, only: [] do
      resources :predictions, only: [:create]
    end
    resources :predictions, only: [:update]
    resources :leagues, only: [:destroy]
    resources :memberships, only: [:destroy]
  end
end
