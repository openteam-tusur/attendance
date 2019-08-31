require 'progress_bar'

task export_users: :environment do
  group_leader_permissions = Permission.where(role: :group_leader)
  pb = ProgressBar.new(group_leader_permissions.count)
  gl_arr = []
  group_leader_permissions.each do |permission|
    gl_arr << { group: permission.context.number, email: permission.email }
    pb.increment!
  end

  File.open('data/group_leaders.json', 'w') do |f|
    f.write(gl_arr.to_json)
  end
end
