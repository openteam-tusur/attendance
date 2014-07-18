SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|
    primary.item :disruptions,   I18n.t('page_title.disruptions.index'),  subdepartment_disruptions_path
    primary.item :statistics,    I18n.t('page_title.groups.index'),       subdepartment_groups_path
  end
end
