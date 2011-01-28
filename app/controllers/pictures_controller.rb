class PicturesController < ApplicationController
# %%co%%pic%%in  %%mo%%pic

# working on

# The sessions controller's update action rebuilds the web page cache,
# thus allowing the webmaster to edit the database at leisure.

  caches_page :except => []
  skip_before_filter :cookies_required
  skip_before_filter :guard_logged_in

  def index
    r=Picture.order 'weight, year DESC, sequence DESC'
    tag=params[:tag]
    r=r.joins(:tags).where :tags => {:name => tag} if tag
    @pictures=r.all
    render :file => (App.webmaster.join 'page'), :layout => false
  end

end
