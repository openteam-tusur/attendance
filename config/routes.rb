Attendance::Application.routes.draw do
  namespace :manage do

    namespace :statistics do
      scope 'losers' do
        get '/lecturers'
        get '/lecturers/:faculty'

        get '/group_leaders'
        get '/group_leaders/:faculty'

        get '/students'
        get '/students/:faculty'
      end
    end

    resources :groups, :only => [] do
      get '/not_marked' => 'not_marked#index', :on => :member
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
      get '/losers/group_leaders'    => 'losers#group_leaders', :as => :losers_group_leaders
      get '/losers/lecturers'        => 'losers#lecturers', :as => :losers_lecturers
      get '/losers/students'         => 'losers#students', :as => :losers_students
    end

    root :to => 'university_statistics#index'
  end

  scope :module => :public do
    get 'search' => 'search#index'
    resources :students, :only => [:show]
  end

  root :to => 'application#main_page'
end
