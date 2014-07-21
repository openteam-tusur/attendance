SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|
    Permission.available_roles.each do |role|
      primary.item role.to_sym, I18n.t("roles_name.#{role}"), [role.to_sym, :root]
    end
  end
end

