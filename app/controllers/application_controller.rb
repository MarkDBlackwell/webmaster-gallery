class ApplicationController < ActionController::Base
  before_filter :cookies_required
  before_filter :guard_http_method
  before_filter :guard_logged_in
# Per http://railsforum.com/viewtopic.php?id=24298 :
  protect_from_forgery # Creates a before-filter which raises the next error.
       # The filter is called, 'verify_authenticity_token'.
  rescue_from ActionController::InvalidAuthenticityToken,
                     :with => :invalid_authenticity_token

#-------------
  private

  def clear_session
    a = session.to_hash.keys - ['flash']
    a += ['flash'] # Seems to work.
    a.each {|e| session.delete e}
  end

  def cookies_required
    handle_missing_cookies if cookies.empty? # action_dispatch.cookies
  end

  def guard_http_method
# Reference: 'ActionController - PROPFIND and other HTTP request methods':
# at http://railsforum.com/viewtopic.php?id=30137
    i=[:create,:destroy,:update].index request.parameters.fetch(:action).to_sym
    restful_method=i.present? ? [:post,:delete,:put].at(i) : :get
    handle_bad_request 'Improper http verb.' unless
        request.request_method_symbol==restful_method
  end

  def guard_logged_in
    handle_bad_request 'Log in required.' unless session[:logged_in]
  end

  def handle_bad_request(message)
    raise if message.blank?
    clear_session
    flash[:error]=message
    redirect_to :controller => :sessions, :action => :new
  end

  def handle_missing_cookies
    clear_session
    flash.now[:error]='Cookies required, or session timed out.'
    @suppress_buttons=true
    render :template => 'sessions/new'
  end

  def invalid_authenticity_token
    cookies.empty? ? handle_missing_cookies : 
        handle_bad_request('Invalid authenticity token.')
  end

end
