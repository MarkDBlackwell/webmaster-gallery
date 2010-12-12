class PicturesController < ApplicationController
  caches_page :index
  skip_before_filter :cookies_required,
      :guard_logged_in

  def index
# The sessions controller (update action) should delete these cached pages.
    uncached_index
  end

  def uncached_index
    @all_tags=Tag.all
    @pictures=Picture.all
    render :file => (App.webmaster.join 'page'), :layout => false
  end

end
