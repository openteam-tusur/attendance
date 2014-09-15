class PriorityPermission < Struct.new(:user)
  def fetch
    Permission.available_roles.each do |role|
      permissions = user.permissions.for_role(role)
      return permissions.first if permissions.any?
    end
  end
end
