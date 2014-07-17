SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|
    primary.item :group1, 'Группа 1', '#'
    primary.item :group2, 'Группа 2', '#'
    primary.item :group3, 'Группа 3', '#'
  end
end
