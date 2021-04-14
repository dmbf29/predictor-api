Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth', controllers: {
    sessions: 'auth/devise_token_auth/sessions'
  }
  namespace :v1 do
    resources :competitions, only: [:show] do
      resources :leagues, only: [:index, :create]
    end
    resources :matches, only: [:index], shallow: true do
      resources :predictions, only: [:create, :update]
    end
    resources :leagues, only: [:destroy], shallow: true do
      resources :memberships, only: [:create, :destroy]
    end
    resources :users, only: [:show]
  end
end
