SimpleNavigation::Configuration.run do |navigation|
  navigation.selected_class = 'active'

  navigation.items do |primary|
    Permission.available_roles.each do |role|
      primary.item role.to_sym, I18n.t("role_names.#{role}"), [role.to_sym, :root] do |role_item|

      if role == 'administrator'
        role_item.item :permissions,  I18n.t('page_title.permissions.index'),   administrator_permissions_path do |permission|
          permission.item :new,       I18n.t('page_title.permissions.new'),     new_administrator_permission_path
        end
        role_item.item :sync,         I18n.t('page_title.syncs.index'),         administrator_syncs_path
        role_item.item :sidekiq,     'Sidekiq',                                 administrator_sidekiq_path
      end

      if role == 'curator'
        role_item.item :groups, I18n.t('page_title.groups.index'), curator_groups_path
      end

      if role == 'dean'
        role_item.item :permissions,  I18n.t('page_title.permissions.index'),   dean_permissions_path do |permission|
          permission.item :new,       I18n.t('page_title.permissions.new'),     new_dean_permission_path
        end
        role_item.item :miss_reason,  I18n.t('page_title.misses.index'),        dean_misses_path
        role_item.item :disruptions,  I18n.t('page_title.disruptions.index'),   dean_disruptions_path
        role_item.item :statistics,   I18n.t('page_title.statistics.index'),    dean_statistics_path
      end

      if role == 'education_department'
        role_item.item :miss_reason,  I18n.t('page_title.misses.index'),       education_department_misses_path
        role_item.item :disruptions,  I18n.t('page_title.disruptions.index'),  education_department_disruptions_path
        role_item.item :statistics,   I18n.t('page_title.statistics.index'),   education_department_statistics_path
        role_item.item :permissions,  I18n.t('page_title.permissions.index'),  education_department_permissions_path
      end

      if role == 'group_leader'
        role_item.item :statistics, I18n.t('page_title.groups.show', :title => current_user.leaded_groups.first),   group_leader_group_path
        role_item.item :lessons,    I18n.t('page_title.lessons.index'),                                             group_leader_lessons_path
      end

      if role == 'lecturer'
        role_item.item :disruptions, I18n.t('page_title.disruptions.index'), lecturer_disruptions_path
        role_item.item :groups,      I18n.t('page_title.groups.index'),      lecturer_groups_path
      end

      if role == 'subdepartment'
        role_item.item :disruptions,   I18n.t('page_title.disruptions.index'),  subdepartment_disruptions_path
        role_item.item :statistics,    I18n.t('page_title.groups.index'),       subdepartment_groups_path
      end

      end if current_user.send("#{role}?")
    end if user_signed_in?
  end
end

SimpleNavigation.register_renderer :first_renderer  => FirstRenderer
SimpleNavigation.register_renderer :second_renderer => SecondRenderer
SimpleNavigation.register_renderer :mobile_menu_renderer => MobileMenuRenderer
