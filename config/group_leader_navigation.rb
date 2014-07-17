SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|
    primary.item :unfilled,   'Незаполненные дни', '#'
    primary.item :statistics, 'Статистика группы', '#'
    primary.item :attendance, 'Заполнение журнала посещаемости', '#'
  end
end
