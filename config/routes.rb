Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root "accounts#index"
  resources :accounts do 
    collection do
      post 'update_accounts'
    end
  end
end
