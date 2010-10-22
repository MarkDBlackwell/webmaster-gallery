module PicturesHelper

  def tags
    concat( render :partial => 'pictures/tags')
  end

  def gallery
    concat( render :partial => 'pictures/gallery')
  end

end
