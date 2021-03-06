SimpleNavigation::Configuration.run do |navigation|
  navigation.selected_class = 'active'

  navigation.items do |primary|
    if user_signed_in?
      Permission.available_roles.reject{ |namespace| namespace == 'education_prorektor' }.each do |role|
        primary.item role.to_sym, I18n.t("role_names.#{role}", title: current_user.title_for_role(role)), [role.to_sym, :root] do |role_item|
        primary.dom_class = 'dropdown-menus'

        if role == 'administrator'
          role_item.item :permissions,  I18n.t('page_title.permissions.index'),   administrator_permissions_path(for_role: (current_namespace == :administrator && params[:for_role]) || :administrator) do |permission|
            permission.item :new,       I18n.t('page_title.permissions.new'),     new_administrator_permission_path
          end
          role_item.item :sync,         I18n.t('page_title.syncs.index'),         administrator_syncs_path
          role_item.item :miss_kinds,   I18n.t('page_title.miss_kinds.index'),    administrator_miss_kinds_path do |miss_kind|
            miss_kind.item :new,        I18n.t('page_title.miss_kinds.new'),      new_administrator_miss_kind_path
            miss_kind.item :edit,       I18n.t('page_title.miss_kinds.edit'),     edit_administrator_miss_kind_path(miss_kind)
          end
        end

        if role == 'curator'
          role_item.item :groups,       I18n.t('page_title.groups.index'),        curator_groups_path, highlights_on: /^\/curator\/groups/ do |group|
            group.item :group,          I18n.t('page_title.groups.show', title: @group.number), curator_group_path(@group) if @group && @group.persisted?
          end
        end

        if role == 'dean'
          role_item.item :permissions,  I18n.t('page_title.permissions.index'),   dean_permissions_path(for_role: (current_namespace == :dean && params[:for_role]) || :group_leader) do |permission|
            permission.item :new,       I18n.t('page_title.permissions.new'),     new_dean_permission_path
          end
          role_item.item :miss_reason,  I18n.t('page_title.misses.index'),        dean_misses_path do |miss|
            miss.item :new,             I18n.t('page_title.misses.new'),          new_dean_miss_path
            miss.item :edit,            I18n.t('page_title.misses.edit'),         edit_dean_miss_path(miss)
          end
          role_item.item :disruptions,  I18n.t('page_title.disruptions.index'),   dean_disruptions_path
          role_item.item :group_leaders,I18n.t('page_title.group_leaders.index'), dean_group_leaders_path
          role_item.item :groups,       I18n.t('page_title.groups.index'),        dean_groups_path, highlights_on: /^\/dean\/groups(?!\/list)|\/dean\/courses|\/dean\/subdepartments/
          role_item.item :groups,       I18n.t('page_title.lecturers.index'),     dean_lecturers_path, highlights_on: /^\/dean\/lecturers/
          role_item.item :students,     I18n.t('page_title.students.index'),      dean_students_path
          role_item.item :groups_list,  I18n.t('page_title.groups.list'),         list_dean_groups_path
        end

        if role == 'education_department'
          role_item.item :faculties_with_groups,
            I18n.t('page_title.filling.index'),
            education_department_filling_faculties_path,
            highlights_on: /^\/education_department\/filling/

          role_item.item :faculties,
            I18n.t('page_title.faculties.index'),
            education_department_faculties_path,
            highlights_on: /^\/education_department\/courses|\/education_department\/faculties|\/education_department\/groups/

          role_item.item :statistics,
            I18n.t('page_title.faculties.statistics'),
            education_department_group_leaders_path

          role_item.item :lecturer_presences,
            I18n.t('page_title.lecturer_presences.title'),
            education_department_lecturer_presences_path

          role_item.item :disruptions,
            I18n.t('page_title.disruptions.index'),
            education_department_disruptions_path

          if current_user.education_prorektor?
            role_item.item :miss_kinds,
              I18n.t('page_title.miss_kinds.index'),
              education_department_miss_kinds_path
          else
            role_item.item :miss_kinds,
              I18n.t('page_title.miss_kinds.index'),
              education_department_miss_kinds_path do |miss_kind|

                miss_kind.item :new,
                  I18n.t('page_title.miss_kinds.new'),
                  new_education_department_miss_kind_path
                miss_kind.item :edit,
                  I18n.t('page_title.miss_kinds.edit'),
                  edit_education_department_miss_kind_path(miss_kind)
              end
          end

          if !current_user.education_prorektor?
            role_item.item :permissions,
              I18n.t('page_title.permissions.index'),
              education_department_permissions_path(
                for_role: (current_namespace == :education_department && params[:for_role]) || :dean
              )
          end
        end

        if role == 'group_leader'
          role_item.item :group,        I18n.t('page_title.groups.index'),        group_leader_group_path, highlights_on: /^\/group_leader\/group/
          role_item.item :lessons,      I18n.t('page_title.lessons.title'),       group_leader_lessons_path
        end

        if role == 'lecturer'
          role_item.item :lecturer_disruptions,  I18n.t('page_title.disruptions.personal'), lecturer_disruptions_path do |lecturer_disruption|
            if @lecturer_declaration.present?
              lecturer_disruption.item :new_lecturer_declaration, I18n.t('page_title.lecturer_declaration.new'), new_lecturer_realize_lecturer_declaration_path(@realize) if @realize.present?
              lecturer_disruption.item :edit_lecturer_declaration, I18n.t('page_title.lecturer_declaration.edit'), edit_lecturer_realize_lecturer_declaration_path(@realize, @lecturer_declaration) if @realize.present? && @lecturer_declaration.persisted?
            end
          end
          role_item.item :disciplines,       I18n.t('page_title.groups.index'),         lecturer_disciplines_path, highlights_on: /^\/lecturer\/groups|\/lecturer\/disciplines/
        end

        if role == 'subdepartment'
          role_item.item :permissions,  I18n.t('page_title.permissions.index'),   subdepartment_permissions_path(for_role: :curator) do |permission|
            permission.item :new,       I18n.t('page_title.permissions.new'),     new_subdepartment_permission_path
          end

          role_item.item :subdepartment_disruptions,  I18n.t('page_title.disruptions.index'),   subdepartment_disruptions_path do |subdepartment_disruption|
            if @subdepartment_declaration.present?
              subdepartment_disruption.item :new_subdepartment_declaration, I18n.t('page_title.subdepartment_declaration.new'), new_subdepartment_realize_subdepartment_declaration_path(@realize) if @realize.present?
              subdepartment_disruption.item :edit_subdepartment_declaration, I18n.t('page_title._declaration.edit'), edit_subdepartment_realize_subdepartment_declaration_path(@realize, @subdepartment_declaration) if @subdepartment_declaration.persisted? && @realize.present?
            end
          end
          role_item.item :groups,       I18n.t('page_title.groups.index'),        subdepartment_groups_path, highlights_on: /^\/subdepartment\/groups|\/subdepartment\/courses/
          role_item.item :groups,       I18n.t('page_title.lecturers.index'),     subdepartment_lecturers_path, highlights_on: /^\/subdepartment\/lecturers/
        end

        if role == 'student'
          role_item.item :my_statistic, 'Моя статистика',                         student_path(current_user.students.first.secure_id)
        end

        end if current_user.send(:has_permission?, role: role)
      end
    else
      primary.item :main_page, I18n.t("page_title.main_page.index"), root_path
    end
    primary.item :questions, 'Тех. поддержка', 'http://profile.tusur.ru/conversations/new?conversation%5Buser_groups%5D%5B%5D=3cf24e4b-f608-43dd-bc22-c5972500eac0', link: { target: '_blank' }
    primary.item :docs, 'Как пользоваться?', docs_path
  end
end

SimpleNavigation.register_renderer first_renderer:  FirstRenderer
SimpleNavigation.register_renderer second_renderer: SecondRenderer
SimpleNavigation.register_renderer mobile_menu_renderer: MobileMenuRenderer
