SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|
    primary.item :disrupted,    'Сорванные занятия', '#'
    primary.item :statistics,   'Статистика', '#'
  end
end
