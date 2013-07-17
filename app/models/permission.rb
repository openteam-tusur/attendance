class Permission < ActiveRecord::Base
  include Enumerize

  def self.validates_presence_of(*attr_names)
    super attr_names - [:user]
  end

  attr_accessible :context, :role, :user_id, :context_id, :context_type, :user_uid,
    :user_name, :user_email, :user_search, :polymorphic_context, :email

  validates_uniqueness_of :role, :scope => [:email, :context_id, :context_type]
  validates_presence_of :email, :context_id, :context_type, :role

  sso_auth_permission(:roles => %w[manager group_leader study_department_worker faculty_worker])

  enumerize :state, :in => [:active, :inactive], :default => :inactive
  enumerize :role, :in => %w[manager group_leader study_department_worker faculty_worker]

  scope :group_leaders, -> { joins(:user).where(:permissions => {:role => :group_leader}).order('ascii(users.last_name)') }
  scope :faculty_workers, -> { where(:role => :faculty_worker) }
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

