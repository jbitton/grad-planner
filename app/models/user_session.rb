require 'singleton'

class UserSession
  include Singleton
  @@user
  def initialize
    @@user = nil
  end

  def invalidate_user
    @@user = nil
  end

  def set_user(user)
    @@user = user
  end

  def get_user
    return @@user
  end

  def get_username
    return user.username
  end

  def is_valid
    return !@@user.nil?
  end

end