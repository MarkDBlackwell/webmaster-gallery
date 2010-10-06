class ApplicationController < ActionController::Base
  protect_from_forgery

# Per http://railsforum.com/viewtopic.php?id=24298 :

  rescue_from ActionController::InvalidAuthenticityToken,
    :with => :invalid_authenticity_token

  def invalid_authenticity_token
    flash[:notice] = 'That session has expired.'
    redirect_to '/login'
  end

end
