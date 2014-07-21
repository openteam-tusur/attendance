SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|
    Permission.available_roles.each do |role|
      primary.item role.to_sym, I18n.t("role_names.#{role}"), [role.to_sym, :root] #if current_user.send("#{role}?")
    end
  end
end

