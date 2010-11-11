class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :guard_http_method
  before_filter :guard_logged_in

# Per http://railsforum.com/viewtopic.php?id=24298 :

  rescue_from ActionController::InvalidAuthenticityToken,
    :with => :invalid_authenticity_token

#-------------
  private

  def clear_session
    session.to_hash.keys.each {|e| session.delete e}
#    (session.to_hash.keys - ['flash']).each {|e| session.delete e}
  end

  def guard_http_method
    i=[:create,:destroy,:update].index request.parameters.fetch(:action).to_sym
    method=i ? [:post,:delete,:put].at(i) : :get
    handle_bad_request 'Improper http verb.' unless
        request.request_method_symbol==method
  end

  def guard_logged_in
    handle_bad_request 'Log in required.' unless session[:logged_in]
  end

  def handle_bad_request(message)
    raise if message.blank?
    clear_session
    flash[:error]=message
    redirect_to :controller => 'sessions', :action => 'new'
  end

  def handle_missing_cookies
      flash.now[:error]='Cookies required, or session timed out.'
      @suppress_buttons=true
      render :controller => 'sessions', :action => 'new'
  end

  def invalid_authenticity_token
    cookies.empty? ? # action_dispatch.cookies
       handle_missing_cookies : 
       handle_bad_request('Invalid authenticity token.')
  end

end
