Rails.application.routes.draw do
  get 'foos/index'

  get 'foo/index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :foos
end
