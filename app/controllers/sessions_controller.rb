class SessionsController < ApplicationController

  def new
# GET /session/new
    return unless check_request
    if session[:logged_in]
      flash[:notice]='You already were logged in.'
      redirect_to :action => 'edit'
    end
  end

  def create
# POST /session
    return unless check_request(request.post?)
    if session[:logged_in]
      flash[:notice]='You already were logged in.'
      redirect_to :action => 'edit'
    else
     clear_session
     if cookies.empty?
        handle_missing_cookies
      else
        if get_password != params[:password]
          flash[:error]='Password incorrect.'
          redirect_to :action => 'new'
        else
          session[:logged_in]=true
          redirect_to :action => 'edit'
        end
      end
    end
  end

  def edit
# GET /session/edit
    return unless check_request
    return unless check_logged_in_and_redirect
  end

  def update
# PUT /session
    return unless check_request(request.put?)
    return unless check_logged_in_and_redirect
    realign_records(FileTag,Tag,:name)
    realign_records(DirectoryPicture,Picture,:filename)
    d = "#{Rails.root}/public/pictures"
    ((Dir.entries(d) - %w[. ..]).collect {|e| [d,e]} << [d,'..','index.html']).
        collect {|a| a.join('/')}.each {|e| File.delete(e) if File.exist?(e)}
    render :action => 'show'
  end

  def show
# GET /session
    return unless check_request
    return unless check_logged_in_and_redirect
  end

  def destroy
# DELETE /session
    return unless check_request(request.delete?)
    was_logged_in = session[:logged_in]
    clear_session
    flash[:notice] = was_logged_in.blank? ? "You weren't logged in." :
      'Logged out successfully.'
    redirect_to :action => 'new'
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
