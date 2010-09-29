class AdminPicturesController < ApplicationController
  def index
    redirect_to '/login' unless session[:logged_in]
  end

end
