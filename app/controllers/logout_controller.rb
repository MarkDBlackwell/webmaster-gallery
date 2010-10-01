class LogoutController < ApplicationController
  def index
    flash[:notice] = session[:logged_in].nil? ?
      "You weren't logged in." : 'Logged out successfully.'
    session[:logged_in] = nil
  end

end
