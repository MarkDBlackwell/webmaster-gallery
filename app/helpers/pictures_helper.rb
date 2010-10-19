module PicturesHelper

  def tags
    concat( render :partial => 'tags')
  end

  def gallery
    concat( render :partial => 'gallery')
  end

  private

  def concat_raw(s)
    concat( raw s)
  end

end
