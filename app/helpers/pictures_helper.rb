module PicturesHelper

  def gallery
    concat_raw '<div class="gallery">'
#    render @pictures
    render :partial => 'pictures', :collection => @pictures
    concat_raw '</div>'
  end

  def tags
    concat_raw '<div class="all-tags"></div>'
  end


  def concat_raw s
    concat( raw s)
  end

end
