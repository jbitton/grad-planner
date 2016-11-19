class HomeController < ApplicationController
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
