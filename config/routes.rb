Rails.application.routes.draw do
  root to: 'questions#index'
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :questions, only: %i[index show new create] do
    resources :answers, only: %i[new create], shallow: true
  end
end
