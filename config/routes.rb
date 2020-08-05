Rails.application.routes.draw do
  namespace :site do
    get 'welcome/index'
  end
  namespace :users_backoffice do
    get 'welcome/index'
  end
  namespace :admins_backoffice do
    get 'welcome/index'
    resources :admins, except: :show
  end
  devise_for :users
  devise_for :admins
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'site/welcome#index'
end
