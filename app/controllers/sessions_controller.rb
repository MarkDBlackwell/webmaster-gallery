class SessionsController < ApplicationController
# %%co%%ses%%cr %%co%%ses%%de %%co%%ses%%ed %%co%%ses%%filt %%co%%ses%%new
# %%co%%ses%%sh %%co%%ses%%up

  before_filter      :avoid_links
  skip_before_filter :find_all_tags,     :only   => [:create,:destroy,:new]
  before_filter      :get_file_analysis, :except => [:create,:destroy,:new]
  skip_before_filter :guard_logged_in,   :only   => [:create,:destroy,:new]

  def create
    was_logged_in=session[:logged_in]
    clear_session
    if was_logged_in
      log_strange 'authenticity-token (or cookie) security failure '\
          '(or program error): '\
          'while session already logged in'
      return head :bad_request
    end
    action=:new
    if get_password==params[:password]
      action=:edit
      session[:logged_in]=true
    else
      flash[:error]='Password incorrect.'
    end
    redirect_to :action => action
  end

  def destroy
    was_logged_in=session[:logged_in]
    clear_session
    flash[:notice]=was_logged_in.blank? ?
        'You weren\'t logged in.' :
        'Logged out successfully.'
    redirect_to :action => :new
  end

  def edit
    s=Struct.new :list, :message
    places = %w[ tag\ file  picture\ directory ]
    models = %w[ FileTag    DirectoryPicture   ]
    @erroneous=models.zip(places).map{|m,p| s.new m.constantize.find(:all).
        select{|e| e.invalid?}, "#{p.capitalize} problems:"}
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
    @review_groups=[s.new pp,"Pictures with database problems:"]
    pi=Picture.find(:all).select{|e| e.invalid?}
    @approval_group=s.new '', pp.empty? && pi.empty? ? update_user_message :
        refresh_database_message
    places = %w[ database ]
    models = %w[ Picture ]
    @erroneous=places.zip(models).map{|p,m| s.new m.constantize.find(:all).
        select{|e| e.invalid?}, "#{p.capitalize} problems:"}
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
    @use_controller=:admin_pictures
  end

  def cache_user_picture_pages # Keep for tests.
  end

  def delete_cache
    public=App.root.join 'public'
    pages=[public.join 'index.html']
    (p=public.join 'pictures').find do |path|
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
    FilePassword.find(:all).first.password
  end

  def log_strange(s)
    logger.warn "W #{s.capitalize}, login attempted from remote IP #{request.
        remote_ip}."
  end

  def refresh_database_message
    'refresh ' + dp
  end

  def update_user_message
    'update-user-pictures'
  end

end
