SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|
    primary.item :permissions, 'Управление правами',    admin_permissions_path
    primary.item :sync,        'Статус синхронизации',  admin_syncs_path
    primary.item :sidekiq,     'Sidekiq',               admin_sidekiq_path
  end
end
