class AdminPicturesController < ApplicationController

  def index
    (handle_bad_request; return) unless request.get?
    redirect_to :controller => :sessions, :action => :new unless session[:logged_in]
  end

  def show
    (handle_bad_request; return) unless request.get?
    redirect_to :controller => :sessions, :action => :new unless session[:logged_in]
  end

  def edit
    (handle_bad_request; return) unless request.get?
    redirect_to :controller => :sessions, :action => :new unless session[:logged_in]
  end

  def update
    (handle_bad_request; return) unless request.put?
    redirect_to :controller => :sessions, :action => :new unless session[:logged_in]
    render :action => :show
  end

  private

  def handle_bad_request
    clear_session
    flash[:error] = "Improper http verb."
    redirect_to :controller => :sessions, :action => :new
  end

  def clear_session
    session.to_hash.keys.each {|e| session.delete e}
  end

end
