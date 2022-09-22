Rails.application.routes.draw do
  resources :tasks
  post 'tasks/:id/active' => 'tasks#active'
  post 'tasks/create_message' => 'tasks#create_message'

  resources :messages

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
