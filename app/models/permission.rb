class Permission < ActiveRecord::Base
  sso_auth_permission :roles => %W(administrator curator dean education_department group_leader lecturer subdepartment)

  normalize_attribute     :email
  validates_presence_of   :user_id, :if => 'email.nil?'
  validates_presence_of   :email,   :if => 'user_id.nil?'
  validates_presence_of   :context_type, :context_id, :unless => ->{ %w(administrator education_department).include?(role) }
  validates_uniqueness_of :role,    :scope => [:context_id, :context_type, :email, :user_id]
  validates_email_format_of :email, :check_mx => true, :allow_nil => true

  def role_text
    I18n.t("role_names.#{role}")
  end
end
