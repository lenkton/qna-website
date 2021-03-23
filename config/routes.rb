Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :questions, only: %i[index show new create destroy update] do
    resources :answers, only: %i[create destroy update], shallow: true
    resources :votes, only: %i[create destroy], shallow: true

    post :set_best_answer, on: :member
  end

  resources :files, only: [:destroy]
  resources :links, only: [:destroy]
  resources :rewards, only: [:index]
end
