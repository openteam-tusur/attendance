SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|
    primary.item :permissions,  I18n.t('page_title.permissions.index'),   admin_permissions_path
    primary.item :sync,         I18n.t('page_title.syncs.index'),         admin_syncs_path
    primary.item :sidekiq,     'Sidekiq',                                 admin_sidekiq_path
  end
end
