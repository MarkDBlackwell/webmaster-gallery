class HomeController < ApplicationController
  def index
    redirect_to :controller => "pictures", :action => "index"
  end

end
