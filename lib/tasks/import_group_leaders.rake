namespace :import do
  task :group_leaders => :environment do
    json = File.open('data/group_leaders.json', 'r').read
    groups_arr = JSON.parse(json)

    groups_arr.each do |group_hash|
      group = Group.find_by(:number => group_hash['group'])
      group.permissions.create(:email => group_hash['email'], :role => 'group_leader') if group && group.permissions.where(:role => 'group_leader').empty?
    end
  end
end
