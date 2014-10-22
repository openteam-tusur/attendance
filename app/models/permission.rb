class Permission < ActiveRecord::Base
  attr_accessor :name

  include AuthClient::Permission

  acts_as_auth_client_permission roles: %W(administrator education_department dean subdepartment curator group_leader lecturer)

  normalize_attribute :email do |value|
    value.presence.present? ? value.downcase : nil
  end

  validates_presence_of   :user_id, :if => 'email.nil?'
  validates_presence_of   :email,   :if => 'user_id.nil?'
  validates_presence_of   :context_type, :context_id, :unless => ->{ %w(administrator education_department).include?(role) }
  validates_uniqueness_of :role,    :scope => [:context_id, :context_type, :email, :user_id],
                                    :message => 'У пользователя не может быть несколько одинаковых ролей'

  validates_uniqueness_of :role,    :scope => [:context_type, :email, :user_id],
                                    :message => ->(error, attributes) { "У одного пользователя не может быть несколько ролей «#{I18n.t("role_names.#{attributes[:value]}", :title => '')}»"},
                                    :if => -> (p) { ['group_leader', 'dean', 'subdepartment', 'lecturer'].include?(p.role) }

  validates_uniqueness_of :role,    :scope => [:context_id, :context_type],
                                    :message => ->(error, attributes) { "У группы не может быть несколько ролей «#{I18n.t("role_names.#{attributes[:value]}", :title => '')}»" },
                                    :if => -> (p) { ['group_leader', 'curator'].include?(p.role) }

  validates_email_format_of :email, :check_mx => true, :allow_nil => true

  scope :for_context, ->(context) { where(:context_type => context)}

  delegate :fullname, :to => :user, :prefix => true, :allow_nil => true

  searchable do
    integer(:context_ids, :multiple => true) { [context_id].compact }

    string :user_fullname

    text :user_email, :using => :email
    text :user_fullname_ru, :using => :user_fullname
    text :user_id
  end

  def self.available_roles_for(role_name)
    case role_name
      when :dean
        [:subdepartment, :group_leader, :curator]
      when :education_department
        [:dean, :subdepartment]
    end
  end

  def role_text
    I18n.t("role_names.#{role}", :title => '').strip
  end

  def to_s
    [user || email, role_text, context].join(', ')
  end
end
