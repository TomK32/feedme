class User < Goldberg::User
  def moderator?
    return role.name == 'Moderator' || role.name == 'Administrator'
  end
  def admin?
    return role.name == 'Administrator'
  end
end
