class HomeController < ApplicationController
  helper_method :do_stuff
  
  def signin
    unless params[:home].nil?
      @username = params[:home][:username]
      @password = params[:home][:password]

      user = User.where(:username => @username).first

      if user && user.password == @password
        redirect_to '/login'
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
        # other attributes?
        # go to new link afterwards
      end
    end
  end
end
