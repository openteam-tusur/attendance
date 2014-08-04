SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|
    primary.item :statistics, I18n.t('page_title.groups.show', :title => current_user.leaded_groups.first),   group_leader_group_path
    primary.item :lessons,    I18n.t('page_title.lessons.index'),                                             group_leader_lessons_path
  end
end
