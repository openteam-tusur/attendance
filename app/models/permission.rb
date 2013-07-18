class Permission < ActiveRecord::Base
  include Enumerize

  attr_accessible :context, :role, :user_id, :context_id, :context_type, :user_uid,
    :user_name, :user_email, :user_search, :polymorphic_context, :email

  def self.validates_presence_of(*attr_names)
    super attr_names - [:user]
  end

  def self.available_roles
    %w[manager group_leader study_department_worker faculty_worker]
  end

  belongs_to :context, :polymorphic => true
  belongs_to :user

  validates_presence_of :email, :context_id, :context_type, :role
  validates_inclusion_of  :role, :in => available_roles + available_roles.map(&:to_sym)
  validates_uniqueness_of :role, :scope => [:email, :context_id, :context_type]

  scope :for_role,    ->(role)    { where :role => role }
  scope :for_context, ->(context) { where :context_id => context.try(:id), :context_type => context.try(:class) }

  enumerize :role, :in => %w[manager group_leader study_department_worker faculty_worker]

  scope :group_leaders, -> { joins(:user).where(:permissions => {:role => :group_leader}).order('ascii(users.last_name)') }
  scope :faculty_workers, -> { where(:role => :faculty_worker) }

  after_create :send_invitation

  def self.activate_for_user(user)
    where(:email => user.email).update_all :user_id => user.id
  end

  def to_s
    user ? "#{user.last_name} #{user.first_name} (#{email})" : email
  end

  private

  def send_invitation
    PermissionMailer.delay.invitation_email(self)
  end
end

# == Schema Information
#
# Table name: permissions
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  context_id   :integer
#  context_type :string(255)
#  role         :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

