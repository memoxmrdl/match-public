Rails.application.routes.draw do
  namespace :api do
    resources :activities, only: [:index]
    resources :teams, only: [:index]
  end
  resources :activities, except: [:index]
  resources :teams, except: [:index, :update]
  resources :main, only: [:index]
  resources :team_invitations, only: [:new, :create, :index]
  devise_for :users
  as :user do
    get '/users' => 'devise_invitable/registrations#new'
    get '/teams' => 'teams#new'
    get '/team_invitation' => 'team_invitations#new'
    get '/activities' => 'activities#new'
  end
  as :team_invitations do
    get '/users/invitation' => 'landing_page#index'
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'landing_page#index'
  namespace :judge do
    resources :activities, only: [:index, :show, :update] do
      resources :activity_status, only: [:create, :destroy]
      resources :feedbacks, only: [:index, :create]
      resources :locations, only: [:update]
    end
    resources :polls, only: [:index, :show] do
      resources :activities, only: [:index] do
        resources :votes, only: [:create, :destroy]
      end
    end
    resources :main, only: [:index]
  end

  namespace :admin do
    resources :user_manager, only: [:index, :update]
    resources :polls, except: [:show]
  end

  resources :activities, only: [:show] do
    resources :feedbacks, only: [:index, :create]
  end

  resources :polls, only: [:index, :show] do
    resources :activities, only: [:index] do
      resources :votes, only: [:create, :destroy]
    end
  end
end
