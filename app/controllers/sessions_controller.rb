class SessionsController < ApplicationController
  def new
    unless request.get?
      session[:logged_in]=nil
      flash[:error] = "Improper http verb."
      redirect_to :action => :new
    else
      redirect_to :action => :destroy if session[:logged_in]
    end
  end

  def create
    unless request.post?
      session[:logged_in]=nil
      flash[:error] = "Improper http verb."
      redirect_to :action => :new
    else
      reset_session
      if get_password != params[:password]
        flash[:error] = "Password incorrect."
        render :action => :new
      else
        session[:logged_in] = true
        copy_webmaster_html_file
        redirect_to :action => :edit
      end
    end
  end

  def edit
  end

  def update
    unless request.put?
      session[:logged_in]=nil
      flash[:error] = "Improper http verb."
      redirect_to :action => :new
    else
      redirect_to :action => :edit
    end
  end

  def show
  end

  def destroy
    unless request.delete?
      session[:logged_in]=nil
      flash[:error] = "Improper http verb."
      redirect_to :action => :new
    else
      was_logged_in = session[:logged_in]
      reset_session
      flash.now[:notice] = was_logged_in.nil? ? "You weren't logged in." :
        'Logged out successfully.'
      redirect_to :action => :edit
    end
  end

  private

  def get_password
    FilePassword.find(:all).first.password
  end

  def copy_webmaster_html_file
    from_f  = "#{Rails.root}/../gallery-webmaster/pictures.html"
    to_f = "#{Rails.root}/app/views/layouts/pictures.html.erb"
    FileUtils.cp from_f, to_f
  end

end
