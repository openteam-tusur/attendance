SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|
    primary.item :miss_reason,  I18n.t('page_title.miss_reasons.index'), education_department_miss_reasons_path
    primary.item :disruptions,  I18n.t('page_title.disruptions.index'),  education_department_disruptions_path
    primary.item :statistics,   I18n.t('page_title.statistics.index'),   education_department_statistics_path
    primary.item :permissions,  I18n.t('page_title.permissions.index'),  education_department_permissions_path
  end
end
