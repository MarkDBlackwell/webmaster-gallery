class LogoutController < ApplicationController
  def index
    was_logged_in = session[:logged_in]
    reset_session
    flash.now[:notice] = was_logged_in.nil? ? "You weren't logged in." :
      'Logged out successfully.'
  end

end
