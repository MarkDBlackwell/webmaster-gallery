class PicturesController < ApplicationController
# %%co%%pic%%in  %%mo%%pic

  caches_page :except => []
  skip_before_filter :cookies_required
  skip_before_filter :guard_logged_in

# The web page cache is rebuilt only by the sessions controller's update action,
# thus allowing the webmaster to edit the database at leisure.

  def index
    @pictures=PictureSet.new params[:tag]
    render :file => (App.webmaster.join 'page'), :layout => false
  end

end
