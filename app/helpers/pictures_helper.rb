module PicturesHelper

  def alltags
    concat( render :partial => 'pictures/all_tags')
  end

  def gallery
    concat( render :partial => 'pictures/gallery')
  end

end
