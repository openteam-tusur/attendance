Attendance::Application.routes.draw do
  namespace :manage do

    namespace :statistics do
      scope 'losers' do
        get '/lecturers' => 'lecturers#index'
        get '/lecturers/:faculty_abbr' => 'lecturers#show'

        get '/group_leaders' => 'group_leaders#index'
        get '/group_leaders/:faculty_abbr' => 'group_leaders#show'

        get '/students' => 'students#index'
        get '/students/:faculty_abbr' => 'students#show'
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
