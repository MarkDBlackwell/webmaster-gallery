class SessionsController < ApplicationController

  def new
    return unless check_request
    redirect_to :action => :destroy if session[:logged_in]
  end

  def create
    return unless check_request(request.post?)
    redirect_to :action => :destroy if session[:logged_in]
    clear_session
    if get_password != params[:password]
      flash[:error] = "Password incorrect."
# TODO: Render or redirect?
#      render :action => :new
      redirect_to :action => :edit
    else
      session[:logged_in] = true
      redirect_to :action => :edit
    end
  end

  def edit
    return unless check_request
#    return unless check_logged_in
  end

  def update
    return unless check_request(request.put?)

#    return unless check_logged_in
    realign_records(FileTag, Tag, :name)
    realign_records(DirectoryPicture, Picture, :filename)
    d = "#{Rails.root}/public/pictures"
    ((Dir.entries(d) - %w[. ..]).collect {|e| [d,e]} << [d,'..','index.html']).
        collect {|a| a.join('/')}.each {|e| File.delete(e) if File.exist?(e)}
    render :action => :show
  end

  def show
    return unless check_request
#    return unless check_logged_in
  end

  def destroy
    return unless check_request(request.delete?)
    was_logged_in = session[:logged_in]
    clear_session
    flash[:notice] = was_logged_in.nil? ? "You weren't logged in." :
      'Logged out successfully.'
    redirect_to :action => :edit
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
