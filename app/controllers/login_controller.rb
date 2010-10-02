class LoginController < ApplicationController
  def index
    redirect_to '/logout' if request.get? && session[:logged_in]
    if request.post?
      reset_session
      if get_password_from_file == params[:password]
        session[:logged_in] = true
        redirect_to '/problems'
        copy_webmaster_html_file
      else
        flash.now[:error] = "Password incorrect."
      end
    end
  end

  private

  def get_password_from_file
    "abc"
  end

  def copy_webmaster_html_file
    input  = "#{Rails.root}/../gallery-webmaster/pictures.html"
    output = "#{Rails.root}/app/views/layouts/pictures.html.erb"
    FileUtils.cp input, output
  end

end
