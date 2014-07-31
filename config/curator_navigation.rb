SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|
    primary.item :groups, I18n.t('page_title.groups.index'), curator_groups_path
  end
end
