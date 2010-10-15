class PicturesController < ApplicationController
  def index
#    render :partial => Pathname.new("#{Rails.root}"\
#      '/../gallery-webmaster/page.html.erb').cleanpath
    render :file => "#{Rails.root}"\
      '/../gallery-webmaster/page.html.erb'
  end

end
