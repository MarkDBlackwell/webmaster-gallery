class LoginController < ApplicationController
  def index
    redirect_to '/logout' if request.get? && session[:logged_in]
    if request.post?
      reset_session
      if get_password == params[:password]
        session[:logged_in] = true
        redirect_to '/problems'
        copy_webmaster_html_file
      else
        flash.now[:error] = "Password incorrect."
      end
    end
  end

  private

  def get_password
#    "abc"
    FilePassword.find(:all).first.password
  end

  def copy_webmaster_html_file
    from_f  = "#{Rails.root}/../gallery-webmaster/pictures.html"
    to_f = "#{Rails.root}/app/views/layouts/pictures.html.erb"
    FileUtils.cp from_f, to_f
  end

end
