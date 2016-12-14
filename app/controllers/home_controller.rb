class HomeController < ApplicationController
  
  def signin
    if session[:current_user_id]
      redirect_to '/session/dashboard'
    end
    unless params[:home].nil?
      @username = params[:home][:username]
      @password = params[:home][:password]
      user = User.where(:username => @username).first
      # UserSession.instance.set_user(user)
      if user && user.password == @password
        session[:current_user_id] = user.id
        redirect_to '/session/dashboard'
      else
        render partial: 'login', layout: '/layouts/home', locals: { invalid: true }
      end
    end
  end

  def signup
    unless params[:home].nil?
      @username = params[:home][:username]
      @password = params[:home][:password]
      @confirm_password = params[:home][:confirm_password]

      user = User.where(:username => @username).first

      if user
        render partial: 'signup', layout: '/layouts/home', locals: { invalid: 'Error: username already exists' }
      elsif @password != @confirm_password
        render partial: 'signup', layout: '/layouts/home', locals: { invalid: 'Error: passwords do not match' }
      else
        @user = User.new
        @user.username = @username
        @user.password = @password
        @user.first_name = ''
        @user.last_name = ''
        @user.major_1 = 0
        @user.credits_taken = 0
        @user.courses_taken = ''
        @user.save
        redirect_to '/home/signin'
      end
    end
  end

  def logout
    session[:current_user_id] = nil
    redirect_to '/home/signin'
  end
end
