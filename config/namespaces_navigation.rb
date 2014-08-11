SimpleNavigation::Configuration.run do |navigation|
  navigation.selected_class = 'active'

  navigation.items do |primary|
    Permission.available_roles.each do |role|
      primary.item role.to_sym, I18n.t("role_names.#{role}"), [role.to_sym, :root] do |role_item|

      if role == 'administrator'
        role_item.item :permissions,  I18n.t('page_title.permissions.index'),   administrator_permissions_path
        role_item.item :sync,         I18n.t('page_title.syncs.index'),         administrator_syncs_path
        role_item.item :sidekiq,     'Sidekiq',                                 administrator_sidekiq_path
      end

      if role == 'curator'
        role_item.item :groups, I18n.t('page_title.groups.index'), curator_groups_path
      end

      end if current_user.send("#{role}?")
    end if user_signed_in?
  end
end

SimpleNavigation.register_renderer :first_renderer  => FirstRenderer
SimpleNavigation.register_renderer :second_renderer => SecondRenderer
SimpleNavigation.register_renderer :mobile_menu_renderer => MobileMenuRenderer
