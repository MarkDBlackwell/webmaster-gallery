class SessionsController < ApplicationController
  skip_before_filter :cookies_required, :only => :new
  before_filter      :get_all_tags,   :except => [:create, :destroy, :new]
  skip_before_filter :guard_logged_in,  :only => [:create, :destroy, :new]

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
    @review_groups, @approval_group = get_groups
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
    s=Struct.new :list, :message
    @review_groups=[s.new Picture.find_database_problems,
        'Pictures with database problems:']
    @approval_group=s.new [], 'refresh'
    render :edit
  end

  def update
    process_changed *get_groups
    delete_cache
    redirect_to :action => :edit
  end

#-------------
  private

  def already_in
    flash[:notice]='You already were logged in.'
    redirect_to :action => :edit
  end

  def delete_cache
    return unless 'update-user-pictures'==params[:commit]
    return if params[:approval_group].present?
    public=App.root.join 'public'
    pages=[public.join 'index.html']
    (p=public.join 'pictures').find do |path|
      next if path==p
      Find.prune if path.directory?
      pages << path
    end
    pages.each{|e| FileUtils.rm e, :force => true}
  end

  def get_all_tags
    @all_tags=Tag.all
  end

  def get_groups
    s=:name
         tn =    ( t =     Tag.order(s).find(:all) ).map &s
    file_tn =          FileTag         .find(:all)  .map(&s).sort
    s=:filename
         pn =    ( p = Picture.order(s).find(:all) ).map &s
    file_pn = DirectoryPicture         .find(:all)  .map(&s).sort
    s=nil
    model_i,operation_i=case
    when (names=(file_tn-tn)).present?
      [0,0]
    when (names=(tn-file_tn)).present?
      records=Tag.order(:name).where(["name IN (?)", names]).all
      [0,1]
    when (names=(file_pn-pn)).present?
      [1,0]
    when (names=(pn-file_pn)).present?
      records=Picture.order(:filename).where(["filename IN (?)", names]).all
      [1,1]
    else  names=[]
      [nil,nil]
    end
    s=Struct.new :list, :message
    unpaired=DirectoryPicture.find_unpaired.sort
    approval=s.new unpaired.present? ? [] : names, 'refresh'
    rm=review_messages
    review=[s.new(file_tn,  rm.shift),
            s.new(unpaired, rm.shift)]
    if unpaired.blank?
      review.concat [s.new(      p, rm.shift),
                     s.new(file_pn, rm.shift)] unless 0==model_i
      if (a=records || names).present?
        m = %w[Tag  Picture].at     model_i
        o = %w[add    delet].at operation_i
        review << s.new(a, "#{m}s to be #{o}ed:")
        approval.message="approve #{o}ing #{m.downcase}s"
      end
    end
    [review, approval]
  end

  def get_password
    FilePassword.find(:all).first.password
  end

  def process_changed(review, approval)
    return if approval.blank? || approval.list.blank? ||
        review.blank? || review.last.blank? || review.last.message.blank?
    return unless approval.list==params[:approval_group].split.sort
    models     = %w[Tag  Picture]
    operations = %w[add  delet]
    model_i, operation_i = (a=[0,1]).product(a).detect{|e|
        "#{models    .at(e.first)}s to be "\
        "#{operations.at(e.last )}ed:"==review.last.message}
    return if model_i.blank? || operation_i.blank?
    model=models.at(model_i).constantize
    method = %w[name  filename].at(model_i)
    case operation_i
    when 0
      approval.list.each{|e| model.create method.to_sym => e}
    when 1
      model.where(["#{method} IN (?)", approval.list ]).all.each{|e| e.destroy}
    end
  end

  def review_messages
    [
        'Tags in file:',
        'Unpaired pictures:',
        'Existing pictures:',
        'Pictures in directory:',
        ]
  end

end
