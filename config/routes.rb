Rails.application.routes.draw do
  scope module: :public do
    get '/search', to: 'search#index'
    get '/students/:id', to: 'students#show', as: :student
    get '/user_attendances/:id', to: 'user_attendances#show'
    root to: 'main_page#index'
  end

  namespace :administrator do
    resources :miss_kinds, except: [:show]
    resources :permissions, only: [:index, :new, :create, :destroy]
    resources :syncs, only: [:index]
    root to: 'syncs#index'
  end

  namespace :curator do
    resources :groups, only: [:index, :show] do
      resources :students, only: [:show]
      resources :lessons, only: :index
    end

    root to: 'groups#index'
  end

  namespace :dean do
    resources :disruptions, only: [:index]
    resources :misses, except: [:show]
    resources :permissions
    resources :group_leaders, only: [:index]
    resources :students, only: [:index] do
      get 'search', on: :collection
    end

    #statistic
    resources :groups, only: [:index, :show] do
      resources :lessons, only: [:index]
      get 'list', on: :collection
      resources :students, only: [:show]
    end
    resources :courses, only: [:show] do
      resources :subdepartments, only: [:show] do
        resources :groups, only: [:show] do
          resources :students, only: [:show]
        end
      end
    end
    resources :subdepartments, only: [:show] do
      resources :courses, only: [:show] do
        resources :groups, only: [:show] do
          resources :students, only: [:show]
        end
      end
    end
    resources :lecturers, only: [:index, :show] do
      resources :disciplines, only: [:index, :show] do
        resources :groups, only: [:show]
      end
    end

    root to: 'groups#index'
  end

  namespace :education_department do
    namespace :filling do
      resources :faculties, only: [:index, :show]
    end

    resources :lecturer_presences, only: [:index] do
      post 'generate_xls', on: :collection
    end
    resources :disruptions
    resources :miss_kinds, except: [:show, :destroy]
    resources :permissions, only: [:index, :new, :create, :destroy]
    resources :realizes, only: [] do
      get 'accept', on: :member
      get 'refuse', on: :member
      get 'change', on: :member
    end

    resources :groups, only: [:show] do
      resources :lessons, only: [:index]
    end

    #statistic
    resources   :courses, only: [:show] do
      resources :faculties, only: [:show] do
        resources :groups, only: [:show] do
          resources :students, only: [:show]
        end
      end
    end

    resources   :faculties, only: [:index, :show] do
      resources :courses, only: [:show] do
        resources :groups, only: [:show] do
          resources :students, only: [:show]
        end
      end
    end

    get 'group_leaders', to: 'group_leaders#index'

    root to: 'faculties#index'
  end

  namespace :group_leader do
    get '/unfilled', to: 'unfilled#index'
    resources :lessons, only: [:index] do
      resources :presences, only: [] do
        get 'change', on: :member
        get 'check_all', on: :collection
        get 'uncheck_all', on: :collection
      end
      resources :realizes, only: [] do
        get 'change', on: :collection
      end
    end

    #statistic
    resource :group, only: [:show] do
      resources :students, only: [:show]
    end

    root to: 'lessons#index'
  end

  namespace :lecturer do
    resources :disruptions
    resources :realizes, only: [] do
      resources :lecturer_declarations, except: [:index, :show]
    end

    #statistic
    resources :disciplines, only: [:index, :show] do
      resources :groups, only: [:show]
    end

    root to: 'disciplines#index'
  end

  namespace :subdepartment do
    resources :disruptions
    resources :permissions
    resources :realizes, only: [] do
      resources :subdepartment_declarations, except: [:index, :show]
    end


    #statistic
    resources :groups, only: [:index, :show] do
      resources :students, only: [:show]
      resources :lessons, only: :index
    end

    resources :courses, only: [:show] do
      resources :groups, only: [:show] do
        resources :students, only: [:show]
      end
    end

    resources :lecturers, only: [:index, :show] do
      resources :disciplines, only: [:index, :show] do
        resources :groups, only: [:show]
      end
    end

    root to: 'disruptions#index'
  end

  resources :users, :only => [] do
    get 'search', on: :collection
  end

  get 'docs' => 'documentation#show'
  mount API => '/'
end
