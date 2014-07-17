require 'sidekiq/web'
Attendance::Application.routes.draw do
  scope :module => :public do
    get '/search' => 'search#index'
    get '/statistic/:uid' => 'statistic#show', :as => :statistic
    root :to => 'main_page#index'
  end

  namespace :admin do
    resources :permissions
    resources :syncs
    mount Sidekiq::Web => '/sidekiq', :as => :sidekiq
    root 'dashboard#index'
  end

  namespace :curator do
    root 'dashboard#index'
  end

  namespace :dean do
    root 'dashboard#index'
  end

  namespace :education_department do
    root 'dashboard#index'
  end

  namespace :group_leader do
    root 'dashboard#index'
  end

  namespace :lecturer do
    root 'dashboard#index'
  end

  namespace :subdepartment do
    root 'dashboard#index'
  end
end
