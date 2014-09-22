class User
  def gravatar_url(*args)
    ''
  end

  def permissions
    Permission.where(:user_id => self.id)
  end

  def fullname
    [surname, name, patronymic].compact.join(' ')
  end
end
