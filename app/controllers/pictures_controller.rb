class PicturesController < ApplicationController
  caches_page :index

  def index
    return unless check_request
# The sessions controller (update action) should delete these cached pages.
    uncached_index
  end

  def uncached_index
    @all_tags = Tag.all
    @pictures = Picture.all
    render :file => "#{Gallery::Application.config.webmaster}/page",
        :layout => false
  end

end
