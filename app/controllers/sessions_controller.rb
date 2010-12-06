class SessionsController < ApplicationController
  skip_before_filter :cookies_required, :only => :new
  before_filter      :get_all_tags,   :except => [:create, :destroy, :new]
  skip_before_filter :guard_logged_in,  :only => [:create, :destroy, :new]

  def new
# GET /session/new
    @suppress_buttons=true
    case
    when cookies.empty? # action_dispatch.cookies
      clear_session
      flash.now[:error]='Cookies required, or session timed out.'
    when session[:logged_in]
      already_in
    end
  end

  def create
# POST /session
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

  def edit
# GET /session/edit
    @review_groups, @approval_group = get_groups
  end

# Working_on

  def update
# PUT /session
    review, approval = get_groups
    process_changed(review, approval) if approval.list.join(' ')==params[
        :approval_group]
    delete_cache if params[:approval_group].blank? && 'update-user-pictures'==
        params[:commit]
    render :action => :edit
  end

  def show
# GET /session
  end

  def destroy
# DELETE /session
    was_logged_in=session[:logged_in]
    clear_session
    flash[:notice]=was_logged_in.blank? ?
        'You weren\'t logged in.' :
        'Logged out successfully.'
    redirect_to :action => :new
  end

#-------------
  private

  def already_in
    flash[:notice]='You already were logged in.'
    redirect_to :action => :edit
  end

  def delete_cache
    public=App.root.join 'public'
    delete=[public.join 'index.html']
    p=public.join 'pictures'
    p.find do |path|
      next if path==p
      Find.prune if path.directory?
      delete << path
    end
    delete.each {|e| FileUtils.rm e, :force => true}
  end

  def get_all_tags
    @all_tags = Tag.all
  end

  def get_groups
         tn =( t =         Tag.find(:all) ).map     &:name
    file_tn =          FileTag.find(:all)  .map     &:name
         pn =( p =     Picture.find(:all) ).map &:filename
    file_pn = DirectoryPicture.find(:all)  .map &:filename
    s=Struct.new :list, :message
    model_i,operation_i=case
    when (names=(file_tn-tn)).present?
      [0,0]
    when (names=(tn-file_tn)).present?
      records=Tag.where(["name IN (?)", names]).all
      [0,1]
    when (names=(file_pn-pn)).present?
      [1,0]
    when (names=(pn-file_pn)).present?
      records=Picture.where(["filename IN (?)", names]).all
      [1,1]
    else  names=[]
      [nil,nil]
    end
    approval=s.new names
    review  =       [s.new file_tn, 'Tags in file:']
    unless 0==model_i
      review.concat [s.new(     p,  'Existing pictures:'),
                     s.new(file_pn, 'Pictures in directory:')]
    end
    if (a = records || names).present?
      m = %w[Tag Picture].at     model_i
      o = %w[add   delet].at operation_i
      approval.message = "approve #{o}ing #{m.downcase}s"
      review << s.new(a, "#{m}s to be #{o}ed:")
    end
    [review, approval]
  end

  def get_password
    FilePassword.find(:all).first.password
  end

  def process_changed(review, approval)
    methods    = %w[name filename]
    models     = %w[Tag Picture]
    operations = %w[added deleted]
    model_i, operation_i = (a=[0,1]).product(a).detect {|e|
        "#{    models.at(e.first)}s to be "\
        "#{operations.at(e.last )}:"==review.last.message}
    return if model_i.blank?
    method=methods.at(model_i)
    model =models .at(model_i).constantize
    case operation_i
    when 0
      approval.list.each {|e| model.create method.to_sym => e}
    when 1
      model.where(["#{method} IN (?)", approval.list ]).all.each {|e| e.destroy}
    end
  end

end
