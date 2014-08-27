namespace :import do
  task :group_leaders => :environment do
    json = File.open('data/group_leaders.json', 'r').read
    groups_arr = JSON.parse(json)

    groups_arr.each do |group_hash|
      group_hash['group']
      group = Group.find_by(:number => group_hash['group'])
      group_hash['email']
      group.permissions.create(:email => group_hash['email'], :role => 'group_leader') if group
    end
  end
end
