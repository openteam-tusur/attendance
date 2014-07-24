SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|
    primary.item :unfilled,   I18n.t('page_title.unfilled.index'),    group_leader_unfilled_path
    primary.item :statistics, I18n.t('page_title.groups.show', :title => nil),       group_leader_group_path(current_user.group)
    primary.item :lessons,    I18n.t('page_title.lessons.index'),     group_leader_lessons_path
  end
end
