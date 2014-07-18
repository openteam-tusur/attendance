require 'sidekiq/web'
Attendance::Application.routes.draw do
  scope :module => :public do
    get '/search' => 'search#index'
    get '/students/:uid' => 'students#show', :as => :student
    root :to => 'main_page#index'
  end

  namespace :admin do
    mount Sidekiq::Web => '/sidekiq', :as => :sidekiq
    resources :permissions
    resources :syncs
    root 'dashboard#index'
  end

  namespace :curator do
    resources :groups
    root 'dashboard#index'
  end

  namespace :dean do
    resources :disruptions
    resources :miss_reasons
    resources :permissions
    resources :statistics
    root 'dashboard#index'
  end

  namespace :education_department do
    resources :disruptions
    resources :permissions
    resources :statistics
    resources :miss_reasons
    root 'dashboard#index'
  end

  namespace :group_leader do
    get '/unfilled' => 'unfilled#index'
    resource :group
    resources :attendances
    root 'dashboard#index'
  end

  namespace :lecturer do
    resources :disruptions
    resources :groups
    root 'dashboard#index'
  end

  namespace :subdepartment do
    resources :disruptions
    resources :groups
    root 'dashboard#index'
  end
end
