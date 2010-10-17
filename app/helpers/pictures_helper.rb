module PicturesHelper

  def tags
    concat_raw '<div class="all-tags"></div>'
  end

  def gallery
    concat_raw '<div class="gallery">'
    Picture.all.each {|e| concat( render :partial => 'picture',
        :locals => {:picture => e} ) }
    concat_raw '</div>'
  end

  private

  def concat_raw s
    concat( raw s)
  end

end
