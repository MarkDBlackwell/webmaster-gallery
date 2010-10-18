class PicturesController < ApplicationController

  def index
    @pictures = Picture.all
    render :file => Webmaster.page_path,
        :layout => false, :collection => false
  end

end

class Webmaster
  def self.page_path
    "#{Rails.root}/../gallery-webmaster/page"
  end

end
