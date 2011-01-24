class PicturesController < ApplicationController
# %%co%%pic%%in

# The sessions controller's update action rebuilds the web page cache,
# thus allowing the webmaster to edit the database at leisure.

  caches_page :except => []
  skip_before_filter :cookies_required
  skip_before_filter :guard_logged_in

  def index
    render_index
  end

#-------------
  private

  def render_index
    fields     = %w[ weight  year  sequence ]
    directions = %w[ ASC     DESC  DESC     ]
    by=fields.zip(directions).map{|f,d| f+' '+d}.join ', '
    @pictures=Picture.order(by).all
    render :file => (App.webmaster.join 'page'), :layout => false
  end

end
