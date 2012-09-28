Attendance::Application.routes.draw do
  namespace :manage do

    resources :groups, :only => [:index] do
      get '/lessons/(:date)' => 'lessons#index',
        :constraints => { :date => /\d{4}-[01][0-9]-[0123][0-9]/ },
        :as => :scoped_lessons

      resources :students, :only => [] do
        resources :lessons do
          resources :presences, :except => :delete
        end
      end
    end

    resources :faculties, :only => [:index, :show] do
      resources :groups, :only => [:show]
    end

    root :to => 'groups#index'
  end

  scope :module => :public do
    get 'search' => 'search#index'
    resources :students, :only => [:show]
  end

  root :to => 'application#main_page'
end
