namespace :statistic do
  desc 'Рассчитать всю статистику'
  task :calculate => :environment do
    presences = Presence.includes(:student, :lesson => [:discipline, :group => [:faculty, :subdepartment]])
        .joins(:lesson   => :realizes)
        .where(:lessons  => { :deleted_at => nil })
        .where(:realizes => { :state => 'was' })
        .where.not(:presences => { :state => nil })

    Statistic::Base.new(nil, presences).process
  end
end
