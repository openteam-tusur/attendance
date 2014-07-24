SimpleNavigation::Configuration.run do |navigation|
  navigation.selected_class = 'active'

  navigation.items do |primary|
    Permission.available_roles.each do |role|
      primary.item role.to_sym, I18n.t("role_names.#{role}"), [role.to_sym, :root] if current_user.send("#{role}?")
    end
  end
end

SimpleNavigation.register_renderer :first_renderer  => FirstRenderer
SimpleNavigation.register_renderer :second_renderer => SecondRenderer
SimpleNavigation.register_renderer :mobile_menu_renderer => MobileMenuRenderer
