SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|
    primary.item :miss_reason,  'Уважительные причины пропуска преподавателями занятий', '#'
    primary.item :disrupted,    'Сорванные занятия', '#'
    primary.item :statistics,   'Статистика', '#'
    primary.item :permissions,  'Управление правами', '#'
  end
end
