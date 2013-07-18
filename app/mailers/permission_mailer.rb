# encoding: utf-8

class PermissionMailer < ActionMailer::Base
  def invitation_email(permission)
    @permission = permission

    mail :to => @permission.email,
      :subject => 'Электронный журнал посещаемости занятий',
      :from => Settings['app.mail_from']
  end
end
