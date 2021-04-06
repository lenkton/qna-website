Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users
  root to: 'questions#index'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :questions, only: %i[index show new create destroy update] do
    resources :answers, only: %i[create destroy update], shallow: true do
      resources :votes, only: %i[create destroy], shallow: true, defaults: { votable: :answers }
      resources :comments, only: %i[create], shallow: true, defaults: { commentable: :answer }
    end

    resources :votes, only: %i[create destroy], shallow: true, defaults: { votable: :questions }
    resources :comments, only: %i[create], shallow: true, defaults: { commentable: :question }

    post :set_best_answer, on: :member
  end

  resources :files, only: [:destroy]
  resources :links, only: [:destroy]
  resources :rewards, only: [:index]

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end

      resources :questions, only: %i[index show create update destroy] do
        resources :answers, only: %i[index show create], shallow: true
      end
    end
  end

  mount ActionCable.server => '/cable'
end
