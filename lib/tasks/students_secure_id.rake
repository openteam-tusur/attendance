namespace :students do
  desc 'Set secure id for students'
  task :set_secure_id => :environment do
    Student.where(:secure_id => nil).each do |student|
      student.set_secure_id
      student.save
    end
  end
end
