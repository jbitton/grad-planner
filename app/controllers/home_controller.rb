class HomeController < ApplicationController
  def index
    @username = params["uname"]
    @password = params["pwd"]


  end
end
