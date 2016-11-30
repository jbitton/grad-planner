class HomeController < ApplicationController
  helper_method :do_stuff

  # this method should be moved to the generation_controller.rb once it is created
  #def find_remaining_courses_for_graduation
   # user = User.where(:username => @username).first
   # major = Major.find(user.major_1)
   # courses_taken = user.course_taken.split(",")
   # requirements = major.requirements.split(",")

   # remaining_courses=requirements-courses_taken
  #end

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
