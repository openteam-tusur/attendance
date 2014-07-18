SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|
    primary.item :disruptions, I18n.t('page_title.disruptions.index'), lecturer_disruptions_path
    primary.item :groups,      I18n.t('page_title.groups.index'),      lecturer_groups_path
  end
end
