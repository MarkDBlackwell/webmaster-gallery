class PicturesController < ApplicationController
  def index
    render :file => "#{Rails.root}/../gallery-webmaster/page", :layout => false
  end

end
