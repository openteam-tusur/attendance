class Permission < ActiveRecord::Base
  sso_auth_permission :roles => %W(administrator curator dean education_department group_leader lecturer subdepartment)
  validates_presence_of :user_id

  def role_text
    I18n.t("role_names.#{role}")
  end
end
