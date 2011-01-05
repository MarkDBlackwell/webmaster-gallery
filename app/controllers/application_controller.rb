class ApplicationController < ActionController::Base
  before_filter :cookies_required
  before_filter :find_all_tags
  before_filter :guard_http_method
  before_filter :guard_logged_in
  protect_from_forgery
  rescue_from ActionController::InvalidAuthenticityToken, :with =>
      :handle_bad_authenticity_token

#-------------
  private

  def clear_session
    a=session.to_hash.keys - ['flash']
    a+=['flash'] # Seems to work.
    a.each{|e| session.delete e}
  end

  def cookies_required
    if cookies.empty? # action_dispatch.cookies
      clear_session # Make doubly sure.
      redirect_to :controller => :sessions, :action => :new
    end
  end

  def find_all_tags
    @all_tags=Tag.all
  end

  def guard_http_method
    i=[:create,:destroy,:update].index request.parameters.fetch(:action).to_sym
    restful_method=i.present? ? [:post,:delete,:put].at(i) : :get
    handle_bad_request 'Improper http verb.' unless
        request.request_method_symbol==restful_method
  end

  def guard_logged_in
    handle_bad_request 'Log in required.' unless session[:logged_in]
  end

  def handle_bad_authenticity_token
    cookies.empty? ? cookies_required : handle_bad_request(
        'Invalid authenticity token.')
  end

  def handle_bad_request(message)
    raise if message.blank?
    clear_session
    flash[:error]=message
    redirect_to :controller => :sessions, :action => :new
  end

end
