SimpleNavigation::Configuration.run do |navigation|
  navigation.selected_class = 'active'

  navigation.items do |primary|
    if user_signed_in?
      Permission.available_roles.each do |role|
        primary.item role.to_sym, I18n.t("role_names.#{role}"), [role.to_sym, :root] do |role_item|
        primary.dom_class = 'dropdown-menus'

        if role == 'administrator'
          role_item.item :permissions,  I18n.t('page_title.permissions.index'),   administrator_permissions_path(:for_role => (current_namespace == :administrator && params[:for_role]) || :administrator) do |permission|
            permission.item :new,       I18n.t('page_title.permissions.new'),     new_administrator_permission_path
          end
          role_item.item :sync,         I18n.t('page_title.syncs.index'),         administrator_syncs_path
          role_item.item :sidekiq,     'Sidekiq',                                 administrator_sidekiq_path
        end

        if role == 'curator'
          role_item.item :groups,       I18n.t('page_title.groups.index'),        curator_groups_path do |group|
            group.item :group,          I18n.t('page_title.groups.show', :title => @group.number), curator_group_path(@group) if @group && @group.persisted?
          end
        end

        if role == 'dean'
          role_item.item :permissions,  I18n.t('page_title.permissions.index'),   dean_permissions_path(:for_role => (current_namespace == :dean && params[:for_role]) || :group_leader) do |permission|
            permission.item :new,       I18n.t('page_title.permissions.new'),     new_dean_permission_path
          end
          role_item.item :miss_reason,  I18n.t('page_title.misses.index'),        dean_misses_path do |miss|
            miss.item :new,             I18n.t('page_title.misses.new'),          new_dean_miss_path
            miss.item :edit,            I18n.t('page_title.misses.edit'),         edit_dean_miss_path(miss)
          end
          role_item.item :disruptions,  I18n.t('page_title.disruptions.index'),   dean_disruptions_path
          role_item.item :group_leaders,I18n.t('page_title.group_leaders.index'), dean_group_leaders_path
          role_item.item :groups,       I18n.t('page_title.groups.index'),        dean_groups_path
          role_item.item :students,     I18n.t('page_title.students.index'),      dean_students_path
        end

        if role == 'education_department'
          role_item.item :permissions,  I18n.t('page_title.permissions.index'),   education_department_permissions_path(:for_role => (current_namespace == :education_department && params[:for_role]) || :dean)
          role_item.item :disruptions,  I18n.t('page_title.disruptions.index'),   education_department_disruptions_path
          role_item.item :faculties,    I18n.t('page_title.faculties.index'),     education_department_faculties_path
        end

        if role == 'group_leader'
          role_item.item :group,        I18n.t('page_title.groups.index'),        group_leader_group_path
          role_item.item :lessons,      I18n.t('page_title.lessons.title'),       group_leader_lessons_path
        end

        if role == 'lecturer'
          role_item.item :disruptions,  I18n.t('page_title.disruptions.personal'), lecturer_disruptions_path
          role_item.item :groups,       I18n.t('page_title.groups.index'),         lecturer_groups_path
        end

        if role == 'subdepartment'
          role_item.item :disruptions,  I18n.t('page_title.disruptions.index'),   subdepartment_disruptions_path
          role_item.item :groups,       I18n.t('page_title.groups.index'),        subdepartment_groups_path
        end

        if role == 'student'
          role_item.item :my_statistic, 'Моя статистика',                         student_path(current_user.students.first.secure_id)
        end

        end if current_user.send("#{role}?")
      end
    else
      primary.item :main_page, I18n.t("page_title.main_page.index"), root_path
    end
  end
end

SimpleNavigation.register_renderer :first_renderer  => FirstRenderer
SimpleNavigation.register_renderer :second_renderer => SecondRenderer
SimpleNavigation.register_renderer :mobile_menu_renderer => MobileMenuRenderer
