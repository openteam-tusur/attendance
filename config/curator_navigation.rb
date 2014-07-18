SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|
    primary.item :groups, I18n.t('page_title.groups.index'), curator_group_path(1)
  end
end
