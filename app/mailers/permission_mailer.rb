# encoding: utf-8

class PermissionMailer < ActionMailer::Base
  default :from => Settings['app.mail_from']

  def invitation_email(permission)
    @permission = permission

    mail :to => @permission.email, :subject => 'Электронный журнал посещаемости занятий'
  end
end
