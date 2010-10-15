module PicturesHelper

  def gallery
    concat_raw '<div class="gallery"></div>'
  end

  def tags
    concat_raw '<div class="all-tags"></div>'
  end


  def concat_raw s
    concat( raw( s))
  end

end
