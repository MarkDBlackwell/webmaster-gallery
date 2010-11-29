class SessionsController < ApplicationController
  skip_before_filter :cookies_required, :only => :new
  skip_before_filter :guard_logged_in, :only => [:create, :destroy, :new]

  def new
# GET /session/new
    @suppress_buttons=true
    case
    when cookies.empty? # action_dispatch.cookies
      clear_session
      flash.now[:error]='Cookies required, or session timed out.'
    when session[:logged_in]
      flash[:notice]='You already were logged in.'
      redirect_to :action => :edit
    end
  end

  def create
# POST /session
    next_action=:edit
    if session[:logged_in]
      flash[:notice]='You already were logged in.'
    else
      clear_session
      if get_password != params[:password]
        flash[:error]='Password incorrect.'
        next_action=:new
      else
        session[:logged_in]=true
      end
    end
    redirect_to :action => next_action
  end

  def edit
# GET /session/edit
    @all_tags = Tag.all
  end

  def update
# PUT /session
    realign_records(FileTag,Tag,:name)
    realign_records(DirectoryPicture,Picture,:filename)
    d = "#{Rails.root}/public/pictures"
    ((Dir.entries(d) - %w[. ..]).collect {|e| [d,e]} << [d,'..','index.html']).
        collect {|a| a.join('/')}.each {|e| FileUtils.rm e, :force => true}
    @all_tags = Tag.all
    render :action => :show
  end

  def show
# GET /session
    @all_tags = Tag.all
  end

  def destroy
# DELETE /session
    was_logged_in = session[:logged_in]
    clear_session
    flash[:notice] = was_logged_in.blank? ? "You weren't logged in." :
      'Logged out successfully.'
    redirect_to :action => :new
  end

#-------------
  private

  def get_password
    FilePassword.find(:all).first.password
  end

  def realign_records(class_1, class_2, symbol)
    a=class_1.find(:all).collect(&symbol)
    b=class_2.find(:all)
    b.each {|e| e.destroy unless a.include? e.send(symbol)}
    (a - b.collect(&symbol)).each {|e| class_2.create symbol => e}
  end

end
