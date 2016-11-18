class HomeController < ApplicationController
  def index
    @username = params["uname"]
    @password = params["pwd"]

    u = User.where(:username => @username).first!

    if u == nil
      # error: invalid username
    end

    if u.password == @password
      # login verified!
    else
      # invalid password
    end
  end
end
