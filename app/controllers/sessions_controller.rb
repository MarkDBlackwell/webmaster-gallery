class SessionsController < ApplicationController
# %%co%%ses%%cr %%co%%ses%%de %%co%%ses%%ed %%co%%ses%%filt %%co%%ses%%new
# %%co%%ses%%sh %%co%%ses%%up %%ses%%si

  before_filter      :avoid_links
  skip_before_filter :find_all_tags,     :only   => [:create,:destroy,:new]
  before_filter      :get_file_analysis, :except => [:create,:destroy,:new]
  skip_before_filter :guard_logged_in,   :only   => [:create,:destroy,:new]
  before_filter      :toggle_login,      :only   => [:create,:destroy]

  def create
    unless get_password==params[:password]
      flash[:error]='Password incorrect.'
      return redirect_to :action => :new
    end
    session[:logged_in]=true
    redirect_to :action => :edit
  end

  def destroy
    logger.info "I Logging out from remote IP #{request.remote_ip}."
    flash[:notice]='Logged out successfully.'
    redirect_to :action => :new
##    stop_server unless STARTED_BY_RAKE
  end

  def edit
    s=Struct.new :list, :message
    places = %w[ tag\ file  picture\ directory ]
    models = %w[ FileTag    DirectoryPicture   ]
    @erroneous=models.zip(places).map{|m,p| s.new m.constantize.all.select{|e|
        e.invalid?}, "#{p.capitalize} problems:"}
    fa=@file_analysis
    flash.now[:notice]="Ready to click the button for #{dp}?" unless (
        fa.files_invalid? || fa.approval_needed?)
    render :single
  end

  def new
    @suppress_buttons=true
    if session[:logged_in]
      flash[:notice]='You already were logged in.'
      redirect_to :action => :edit
    end
  end

  def show
    fa=@file_analysis
    (redirect_to :action => :edit; return) if fa.files_invalid? || 
        fa.approval_needed?
    s=Struct.new :list, :message
    pp=Picture.find_database_problems
    @review_groups=[]
    pi=Picture.all.select{|e| e.invalid?}
    @approval_group=s.new '', pp.empty? && pi.empty? ? update_user_message :
        refresh_database_message
    places = %w[ database ]
    models = %w[ Picture ]
    @erroneous=places.zip(models).map{|p,m| s.new m.constantize.all.select{|e|
        e.invalid?}, "#{p.capitalize} problems:"}
    render :single
  end

  def update
    action=:edit
    pa=params[:approval_group]
    fa=@file_analysis
    case
    when fa.files_invalid?
    when pa.present? && (pa.split.sort.join ' ')==@approval_group.list
      fa.make_changes
    when pa.blank? && update_user_message==params[:commit] &&
        ! FileAnalysis.new.approval_needed? &&
        Picture.find_database_problems.empty?
      delete_cache
      cache_user_picture_pages
      flash[:notice]='Updating user pictures.'
      action=:show
    else action=:show if refresh_database_message==params[:commit] end
    redirect_to :action => action
  end

#-------------
  private

  def avoid_links
    @link_controller=:admin_pictures
  end

  def cache_user_picture_pages # Keep for tests.
  end

  def delete_cache
    public=App.root.join 'public'
    u=my_url_prefix
    u.blank? ? (s='index'; a=[]) : (s=u; a=[u])
#   pages=[public.join "#{s}.html"]
    pages=[public.join("#{s}.html")]
    (p=public.join *a << 'pictures').find do |path|
      next if path==p
      Find.prune if path.directory?
      pages << path
    end
    pages.each{|e| FileUtils.rm e, :force => true}
  end

  def dp
    'database problems'
  end

  def get_file_analysis
    %w[FileTag DirectoryPicture].each{|e| e.constantize.read}
    a=@file_analysis=FileAnalysis.new    
     @review_groups,  @approval_group =
    a.review_groups, a.approval_group
  end

  def get_password
    FilePassword.first.password
  end

  def log_strange(s)
    logger.warn "W #{s.capitalize}, login attempted from remote IP #{request.
        remote_ip}."
  end

  def my_url_prefix
    'webmas-gallery'
  end

  def refresh_database_message
    'refresh ' + dp
  end

  WEBRICK_PID_PATH=App.root.join *%w[ tmp pids server.pid ]
  WEBRICK_PID = begin
    f=File.new WEBRICK_PID_PATH.to_s, 'r'
    s=f.gets("\n").chomp "\n"
    f.close
    s.to_i if s.present?
  rescue Errno::ENOENT
    nil
  end
  APPLICATION_PID=Process.pid

  def stop_application(s)
    logger.info "I #{s}; sending INT to application PID #{APPLICATION_PID}"
    Process.kill 'INT', APPLICATION_PID
  end

=begin
  def stop_server
# Attempt to stop Webrick server gracefully by sending it SIGINT:
    webrick_killed=false
    if WEBRICK_PID.present? && WEBRICK_PID > 0
      begin
        logger.info "I sending INT to Webrick PID #{WEBRICK_PID}; application PID is #{APPLICATION_PID}"
        Process.kill 'INT', WEBRICK_PID
        webrick_killed=true
      rescue Errno::EINVAL, Errno::ESRCH
      end
    end
# Handle various unusual conditions:
    s=case
    when WEBRICK_PID.blank?
      'No Webrick server.pid file found'
    when (WEBRICK_PID <= 0)
      "Bad value in Webrick server.pid file: #{WEBRICK_PID}"
    when (WEBRICK_PID != APPLICATION_PID)
      "Server PID #{WEBRICK_PID} differs from application's: not Webrick?"
    when (!webrick_killed)
      "No process #{WEBRICK_PID}"
# TODO: Handle hung Webrick server?
    end
    stop_application s if s
  end
=end

  def toggle_login
    l=session[:logged_in]
    clear_session
    if l^(params['action']=='destroy')
      log_strange "authenticity-token (or cookie) security failure "\
          "(or program error): "\
          "while session #{l ? 'already':'not'} logged in"
# Ref. en.wikipedia.org/wiki/List_of_HTTP_status_codes .
# TODO: maybe send HTTP status 204, 'No content'.
      head :bad_request
    end
  end

  def update_user_message
    'update-user-pictures'
  end

end
