Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :foos do
    post 'namechange/:name', to: 'foos#namechange', on: :collection, as: :namechange
  end
end
