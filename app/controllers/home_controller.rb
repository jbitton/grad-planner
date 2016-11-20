class HomeController < ApplicationController
  helper_method :do_stuff

  def find_remaining_courses_for_graduation
    user = User.find(10)
    major = Major.find(user.major_1)
    coursesTaken = user.course_taken.split(",")
    requirements = major.requirements.split(",")

    remaining=requirements-coursesTaken

    puts "\nCourses taken ARE:\n"+coursesTaken.to_s+"\n"
    puts "\nMajor "+user.major_1.to_s+" requirements ARE:\n"+requirements.to_s+"\n\n"
    puts "\nRemaining courses ARE:\n"+remaining.to_s+"\n\n"
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
