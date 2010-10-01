class LoginController < ApplicationController
  def index
    redirect_to '/logout' if request.get? && session[:logged_in]
    if request.post?
      reset_session
      if get_password_from_file == params[:password]
        session[:logged_in] = true
        redirect_to '/problems'
      else
        flash.now[:error] = "Password incorrect."
      end
    end
  end

  private

  def get_password_from_file
    "abc"
  end

end
