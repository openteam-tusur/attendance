SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|
    primary.item :unfilled,   I18n.t('page_title.unfilled.index'),    group_leader_unfilled_path
    primary.item :statistics, I18n.t('page_title.group.show'),        group_leader_group_path
    primary.item :attendance, I18n.t('page_title.attendances.index'), group_leader_attendances_path
  end
end
