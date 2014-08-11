SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|
    primary.item :permissions,  I18n.t('page_title.permissions.index'),   dean_permissions_path(:for_role => :group_leader)
    primary.item :miss_reason,  I18n.t('page_title.misses.index'),        dean_misses_path
    primary.item :disruptions,  I18n.t('page_title.disruptions.index'),   dean_disruptions_path
    primary.item :statistics,   I18n.t('page_title.statistics.index'),    dean_statistics_path
  end
end
