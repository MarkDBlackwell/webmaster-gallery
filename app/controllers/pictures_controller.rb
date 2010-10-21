class PicturesController < ApplicationController
  caches_page :index

  def index
# The sessions controller (update action) deletes these cached pages.
    uncached_index
  end

  def uncached_index
    @all_tags = Tag.all
    @pictures = Picture.all
    render :file => Webmaster.page_path,
        :layout => false
  end

end

class Webmaster
  def self.page_path
    "#{Rails.root}/../gallery-webmaster/page"
  end

end
