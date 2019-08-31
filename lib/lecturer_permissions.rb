class LecturerPermissions
  def initialize(lecturer, emails)
    @lecturer = lecturer
    @emails = emails
  end

  def exist_permissions
    @exist_permissions ||= @lecturer.permissions
  end

  def permissions_query
    new_permissions = []

    @emails.each do |email|
      next unless email.present?
      new_permissions << @lecturer.permissions.find_or_create_by(role: :lecturer, email: email)
    end

    absent_permissions = exist_permissions - new_permissions

    del_permissions(absent_permissions) if absent_permissions.any?
  end

  private

  def del_permissions(permissions)
    permissions.map(&:destroy)
  end
end
