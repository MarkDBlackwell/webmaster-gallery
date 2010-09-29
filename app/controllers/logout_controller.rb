class LogoutController < ApplicationController
  def index
    session[:logged_in]=nil
  end

end
