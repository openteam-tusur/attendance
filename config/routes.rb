Attendance::Application.routes.draw do
  namespace :manage do

    resources :groups, :only => [] do
      get '/lessons/(:date)' => 'lessons#index',
        :constraints => { :date => /\d{4}-[01][0-9]-[0123][0-9]/ },
        :as => :scoped_lessons

      resources :lessons, :only => [] do
        put 'switch_state' => 'lessons#switch_state'
      end

      resources :students, :only => [] do
        resources :lessons, :only => [] do
          resources :presences, :only => [:show, :update, :edit]
        end
      end
    end

    resources :faculties, :only => [:show] do
      resources :groups, :only => [:show]
    end

    root :to => 'university_statistics#index'
  end

  scope :module => :public do
    get 'search' => 'search#index'
    resources :students, :only => [:show]
  end

  root :to => 'application#main_page'
end
