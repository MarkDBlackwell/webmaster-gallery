class ApplicationController < ActionController::Base
  protect_from_forgery

# Per http://railsforum.com/viewtopic.php?id=24298 :

  rescue_from ActionController::InvalidAuthenticityToken,
    :with => :invalid_authenticity_token

#-------------
  private

  def check_logged_in_and_redirect
    boolean = session[:logged_in]
    handle_bad_request('Log in required.') unless boolean
    boolean
  end

  def check_request(boolean = request.get?)
    handle_bad_request('Improper http verb.') unless boolean
    boolean
  end

  def clear_session
    session.to_hash.keys.each {|e| session.delete e}
#    (session.to_hash.keys - ['flash']).each {|e| session.delete e}
  end

  def handle_bad_request(message)
    raise if message.blank?
    clear_session
    flash[:error]=message
    redirect_to :controller => 'sessions', :action => 'new'
  end

  def handle_missing_cookies
      flash.now[:error]='Cookies required, or session timed out.'
      render :controller => 'sessions', :action => 'new'
  end

  def invalid_authenticity_token
    cookies.empty? ? # action_dispatch.cookies
       handle_missing_cookies : 
       handle_bad_request('Invalid authenticity token.')
  end

end
