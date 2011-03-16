class ApplicationController < ActionController::Base
# %%co%%app%%filt

  protect_from_forgery # Keep prior to filter, 'cookies_required'. Throws this:
  rescue_from ActionController::InvalidAuthenticityToken,
       :with => :handle_bad_authenticity_token

  before_filter :cookies_required
  before_filter :find_all_tags
  before_filter :guard_http_method
  before_filter :guard_logged_in

#-------------
  private

  def clear_session
# TODO: For the cookie store, write alert-me when ActionController::Base#reset_session does something or works.
    s=session.to_hash.keys-(f=['flash'])
    s.concat(seems_to_work=f).each{|e| session.delete e}
  end

  def cookies_required
    return unless cookies.empty? # action_dispatch.cookies
    clear_session # Make doubly sure.
# TODO: write alert-me test for params responding to 'values_at'.
    e,m=:error, 'Cookies required (or timeout).'
    (flash.now[e]=m; return) if params['controller']=='sessions' &&
                                params['action'    ]=='new'
    flash[e]=m
    redirect_to :controller => :sessions, :action => :new
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
    unless cookies.empty?
      handle_bad_request 'Invalid authenticity token.'
    else
      flash[:error]='Session (or cookie) timed out.'
      cookies_required
    end
  end

  def handle_bad_request(message)
    clear_session
    flash[:error]=message
    redirect_to :controller => :sessions, :action => :new
  end

end
