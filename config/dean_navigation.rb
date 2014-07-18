SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|
    primary.item :permissions,  I18n.t('page_title.permissions.index'),   dean_permissions_path
    primary.item :miss_reason,  I18n.t('page_title.miss_reasons.index'),  dean_miss_reasons_path
    primary.item :disruptions,  I18n.t('page_title.disruptions.index'),   dean_disruptions_path
    primary.item :statistics,   I18n.t('page_title.statistics.index'),    dean_statistics_path
  end
end
