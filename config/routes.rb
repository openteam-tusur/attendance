require 'sidekiq/web'
Attendance::Application.routes.draw do
  devise_for :users, :path => 'auth', :controllers => {:omniauth_callbacks => 'sso/auth/omniauth_callbacks'}, :skip => [:sessions]

  devise_scope :users do
    get 'sign_out' => 'sso/auth/sessions#destroy', :as => :destroy_user_session
    get 'sign_in' => redirect('/auth/auth/identity'), :as => :new_user_session
  end

  scope :module => :public do
    get '/search' => 'search#index'
    get '/students/:id' => 'students#show', :as => :student
    root :to => 'main_page#index'
  end

  namespace :administrator do
    mount Sidekiq::Web => '/sidekiq', :as => :sidekiq
    resources :permissions, :only => [:index, :new, :create, :destroy]
    resources :syncs,       :only => [:index]
    root 'syncs#index'
  end

  namespace :curator do
    resources :groups,      :only => [:index, :show]
    root 'groups#index'
  end

  namespace :dean do
    resources :disruptions,   :only => [:index]
    resources :misses,        :except => [:show]
    resources :permissions
    resources :groups,        :only => [:index, :show]
    resources :group_leaders, :only => [:index]
    resources :students,      :only => [:index] do
      get 'search', :on => :collection
    end
    root 'groups#index'
  end

  namespace :education_department do
    resources :disruptions
    resources :permissions, :only => [:index, :new, :create, :destroy]
    resources :faculties,   :only => [:index, :show]
    resources :misses, :except => [:show]
    get 'lecturers' => 'lecturers#index'
    root 'faculties#index'
  end

  namespace :group_leader do
    get '/unfilled' => 'unfilled#index'
    resource :group,       :only => [:show]
    resources :lessons,    :only => [:index] do
      resources :presences, :only => [] do
        get 'change', :on => :member
        get 'check_all', :on => :collection
        get 'uncheck_all', :on => :collection
      end
      resources :realizes, :only => [] do
        get 'change', :on => :collection
      end
    end
    root 'lessons#index'
  end

  namespace :lecturer do
    resources :disruptions
    resources :groups
    root 'groups#index'
  end

  namespace :subdepartment do
    resources :disruptions
    resources :groups
    root 'disruptions#index'
  end
end
