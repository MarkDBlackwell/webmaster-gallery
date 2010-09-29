class ProblemsController < ApplicationController
  def index
    redirect_to :controller => "login",
      :action => "index" unless session[:logged_in]
  end
end
