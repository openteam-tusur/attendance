Attendance::Application.routes.draw do
  namespace :manage do

    resources :groups do
      get '/lessons/:date' => 'lessons#index',
        :constraints => {:date => /\d{4}-[01][0-9]-[0123][0-9]/},
        :as => :scoped_lessons
    end

    root :to => 'groups#index'
  end

  root :to => 'application#main_page'
end
