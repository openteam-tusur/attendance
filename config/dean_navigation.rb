SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|
    primary.item :permissions,  'Управление старостами', '#'
    primary.item :miss_reason,  'Уважительные причины пропуска студентами занятий', '#'
    primary.item :disrupted,    'Сорванные занятия', '#'
    primary.item :statistics,   'Статистика', '#'
  end
end
