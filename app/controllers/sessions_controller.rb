class SessionsController < ApplicationController
  before_filter      :avoid_links
  skip_before_filter :cookies_required,  :only   => :new
  skip_before_filter :find_all_tags,     :only   => [:create,:destroy,:new]
  before_filter      :get_file_analysis, :except => [:create,:destroy,:new]
  skip_before_filter :guard_logged_in,   :only   => [:create,:destroy,:new]

  def create
    (already_in; return) if session[:logged_in]
    clear_session
    if get_password==params[:password]
      action=:edit
      session[:logged_in]=true
    else
      action=:new
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
  end

  def new
    @suppress_buttons=true
    case when cookies.empty? # action_dispatch.cookies
      clear_session
      flash.now[:error]='Cookies required, or session timed out.'
    when session[:logged_in]
      already_in
    end
  end

  def show
    (redirect_to :action => :edit; return) if @file_analysis.approval_needed?
    s=Struct.new :list, :message
    @review_groups=[s.new Picture.find_database_problems,
                        'Pictures with database problems:']
    @approval_group=s.new '', 'refresh database problems'
    render :edit
  end

  def update
    action=:edit
    pa=params[:approval_group]
# TODO: Add: on update, if pa.blank? it is an error, I think.
    case
    when pa.present? && (pa.split.sort.join ' ')==@approval_group.list
      @file_analysis.make_changes
    when pa.blank? && 'update-user-pictures'==params[:commit] &&
        ! (a=FileAnalysis.new).approval_needed? &&
        Picture.find_database_problems.empty?
      delete_cache
    else action=:show if 'refresh database problems'==params[:commit] end
    redirect_to :action => action
  end

#-------------
  private

  def already_in
    flash[:notice]='You already were logged in.'
    redirect_to :action => :edit
  end

  def avoid_links
    @use_controller=:admin_pictures
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

  def get_file_analysis
    a=@file_analysis=FileAnalysis.new    
     @review_groups,  @approval_group =
    a.review_groups, a.approval_group
  end

  def get_password
    FilePassword.find(:all).first.password
  end

end
