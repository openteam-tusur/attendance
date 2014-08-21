namespace :statistic do
  desc 'Рассчитать всю статистику'
  task :calculate => :environment do
    presences = Presence.includes(:student => [:misses], :lesson => [:discipline, :group => [:faculty, :subdepartment], :realizes => [:lecturer]])
        .joins(:lesson   => :realizes)
        .where(:lessons  => { :deleted_at => nil })
        .where(:realizes => { :state => 'was' })
        .where.not(:presences => { :state => nil })

    connection = Redis.new(:url => Settings['statistic.url'])
    Statistic::Base.new(nil, presences, connection).process
  end
end
