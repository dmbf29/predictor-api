Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  namespace :v1 do
    resources :competitions, only: [] do
      resources :matches, only: [:index]
      resources :leagues, only: [:index, :create, :destroy]
      resources :users, only: [:show]
      resources :memberships, only: [:create, :destroy]
    end
    resources :matches, only: [] do
      resources :predictions, only: [:create, :update]
    end
  end
end
