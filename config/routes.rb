Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth', controllers: {
    sessions: 'auth/devise_token_auth/sessions'
  }
  namespace :v1, defaults: { format: :json } do
    resources :competitions, only: [:show] do
      resources :leaderboards, only: [:index, :create]
    end
    resources :matches, only: [:index], shallow: true do
      resources :predictions, only: [:create]
      patch :predictions, to: 'predictions#update', as: :prediction
    end
    resources :leaderboards, only: [:destroy], shallow: true do
      resources :memberships, only: [:create, :destroy]
    end
    resources :users, only: [:show, :update]
    get 'join/:password', to: 'memberships#create'
  end
end
