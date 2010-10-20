class PicturesController < ApplicationController

  def index
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
