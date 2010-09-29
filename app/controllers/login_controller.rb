class LoginController < ApplicationController
  def index
    session[:logged_in] = get_password_from_file == params[:password] ? 
      true : nil
  end

  private

  def get_password_from_file
    "abc"
  end

end
