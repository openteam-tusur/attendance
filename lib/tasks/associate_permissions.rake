task associate_permissions: :environment do
  users_json = JSON.parse(File.open('data/imported_valid_users.json', 'r').read)

  users_json.each do |info|
    Permission.where(old_user_uid: info['uid']).update_all(user_id: info['id'])
  end
end
