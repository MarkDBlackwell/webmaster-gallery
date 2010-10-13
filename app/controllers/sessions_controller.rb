class SessionsController < ApplicationController
  def new
    (handle_bad_request; return) unless request.get?
    redirect_to :action => :destroy if session[:logged_in]
  end

  def create
    (handle_bad_request; return) unless request.post?
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
    (handle_bad_request; return) unless request.get?
  end

  def update
    (handle_bad_request; return) unless request.put?
    realign_records(FileTag, Tag, :name)
    realign_records(DirectoryPicture, Picture, :filename)
    copy_webmaster_html_file
    redirect_to :action => :show
  end

  def show
    (handle_bad_request; return) unless request.get?
  end

  def destroy
    (handle_bad_request; return) unless request.delete?
    was_logged_in = session[:logged_in]
    clear_session
    flash[:notice] = was_logged_in.nil? ? "You weren't logged in." :
      'Logged out successfully.'
    redirect_to :action => :edit
  end

  private

  def get_password
    FilePassword.find(:all).first.password
  end

  def copy_webmaster_html_file
    from_f  = "#{Rails.root}/../gallery-webmaster/pictures.html"
    to_f = "#{Rails.root}/app/views/layouts/pictures.html.erb"
    FileUtils.cp from_f, to_f
  end

  def handle_bad_request
    clear_session
    flash[:error] = "Improper http verb."
    redirect_to :action => :new
  end

  def clear_session
#    (session.to_hash.keys - ['flash']).each {|e| session.delete(e)}
    session.to_hash.keys.each {|e| session.delete e}
#print session.inspect
  end

  def realign_records(class_1, class_2, symbol)
    a=class_1.find(:all).collect(&symbol)
    b=class_2.find(:all)
    b.each {|e| e.destroy unless a.include? e.send(symbol)}
    (a - b.collect(&symbol)).each {|e| class_2.create symbol => e}
  end

end
