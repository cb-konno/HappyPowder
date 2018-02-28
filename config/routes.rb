Rails.application.routes.draw do
  root 'tasks#index'
  resources :tasks
  resources :users
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'
end
