class PicturesController < ApplicationController
  caches_page :index
  skip_before_filter :cookies_required
  skip_before_filter :guard_logged_in

  def index
# The sessions controller (update action) should delete these cached pages.
    uncached_index
  end

  def uncached_index
    fields     = %w[ weight  year  sequence ]
    directions = %w[ ASC     DESC  DESC     ]
    by=fields.zip(directions).map{|f,d| f+' '+d}.join ', '
    @pictures=Picture.order(by).all
    render :file => (App.webmaster.join 'page'), :layout => false
  end

end
