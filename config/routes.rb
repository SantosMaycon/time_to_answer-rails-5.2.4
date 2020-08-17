Rails.application.routes.draw do
  namespace :site do
    get 'welcome/index'
    get 'search', to: 'search#questions'
    post 'answer', to: 'answer#question'
    get 'search_subject/:subject_id/:subject', to: 'search#subject', as: 'search_subject'
  end
  namespace :users_backoffice do
    get 'welcome/index'
  end
  namespace :admins_backoffice do
    get 'welcome/index'  # home
    resources :admins    # admins crud
    resources :subjects  # subjects crud
    resources :questions # questions crud
  end
  devise_for :users
  devise_for :admins
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'site/welcome#index'
end
