class AdminPicturesController < ApplicationController
  def index
    redirect_to :controller => :sessions, :action => :new unless session[:logged_in]
  end

end
