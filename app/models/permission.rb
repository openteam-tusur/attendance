class Permission < ActiveRecord::Base
  sso_auth_permission :roles => %W(administrator curator dean education_department group_leader lecturer subdepartment)
end
