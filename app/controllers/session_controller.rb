class SessionController < ApplicationController
  def dashboard
    unless UserSession.instance.is_valid
      redirect_to '/home/signin'
    end
  end

  def generate
    unless UserSession.instance.is_valid
      redirect_to '/home/signin'
    end
  end

  def settings
    unless UserSession.instance.is_valid
      redirect_to '/home/signin'
    end
  end
end
