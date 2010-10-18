module PicturesHelper

  def tags
    concat_raw '<div class="all-tags"></div>'
  end

  def gallery
    concat( render :partial => 'gallery')
  end

  private

  def concat_raw(s)
    concat( raw s)
  end

end
