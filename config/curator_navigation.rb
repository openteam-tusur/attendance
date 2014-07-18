SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|
    primary.item :group1, 'Группа 1', curator_group_path(1)
  end
end
