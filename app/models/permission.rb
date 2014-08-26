class Permission < ActiveRecord::Base
  sso_auth_permission :roles => %W(administrator curator dean education_department group_leader lecturer subdepartment student)

  after_save  :notify_about_add, :if => ->(p) { p.user_changed? && p.notifiable? }
  after_destroy :notify_about_delete, :if => ->(p) { p.with_user? && p.notifiable? }

  normalize_attribute     :email
  validates_presence_of   :user_id, :if => 'email.nil?'
  validates_presence_of   :email,   :if => 'user_id.nil?'
  validates_presence_of   :context_type, :context_id, :unless => ->{ %w(administrator education_department).include?(role) }
  validates_uniqueness_of :role,    :scope => [:context_id, :context_type, :email, :user_id],
                                    :message => 'У пользователя не может быть несколько одинаковых ролей'

  validates_uniqueness_of :role,    :scope => [:context_type, :email, :user_id],
                                    :message => ->(error, attributes) { "У одного пользователя не может быть несколько ролей «#{I18n.t("role_names.#{attributes[:value]}")}»"},
                                    :if => -> (p) { ['group_leader', 'dean', 'subdepartment', 'lecturer'].include?(p.role) }

  validates_uniqueness_of :role,    :scope => [:context_id, :context_type],
                                    :message => ->(error, attributes) { "У группы не может быть несколько ролей «#{I18n.t("role_names.#{attributes[:value]}")}»" },
                                    :if => -> (p) { ['group_leader', 'curator'].include?(p.role) }

  validates_email_format_of :email, :check_mx => true, :allow_nil => true

  scope :for_context, ->(context) { where(:context_type => context)}

  def self.available_roles_for(role_name)
    case role_name
      when :dean
        [:group_leader, :curator]
      when :education_department
        [:dean, :subdepartment]
    end
  end

  def role_text
    I18n.t("role_names.#{role}")
  end

  def to_s
    [user || email, role_text, context].join(', ')
  end

  def notifiable?
    !['student'].include?(self.role)
  end

  def with_user?
    self.user
  end

  def user_changed?
    self.user_id_changed?
  end

  private

  def notify_about_delete
    redis = Redis.new(:url => Settings['messaging.url'])
    index = redis.incr("profile:attendance:del_permission:index")
    redis.set "profile:attendance:del_permission:#{index}", { :uid => self.user.uid, :role => self.role }.to_json
  end

  def notify_about_add
    redis = Redis.new(:url => Settings['messaging.url'])
    index = redis.incr("profile:attendance:add_permission:index")
    redis.set "profile:attendance:add_permission:#{index}", { :uid => self.user.uid, :role => self.role }.to_json
  end
end
