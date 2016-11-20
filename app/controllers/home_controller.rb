class HomeController < ApplicationController
  helper_method :do_stuff

  # this method should be moved to the generation_controller.rb once it is created
  def find_remaining_courses_for_graduation
    user = User.where(:username => @username).first
    major = Major.find(user.major_1)
    courses_taken = user.course_taken.split(",")
    requirements = major.requirements.split(",")

    remaining_courses=requirements-courses_taken
  end


  def index
    @username = params["uname"]
    @password = params["pwd"]

    u = User.where(:username => @username).first

    if u == nil
      puts "Error"
    else
      if u.password == @password
        puts "Login"
      else
        puts "Bad credentials"
      end
    end
  end
end
