class ProblemsController < ApplicationController
  def index
    redirect_to :controller => "pictures",
      :action => "index" unless session[:logged_in]
  end
end
