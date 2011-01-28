module PicturesHelper
# %%vi%%he%%pic %%pic%%atag  %%pic%%gal

  def alltags
    concat( render :partial => 'pictures/all_tags' )
    nil
  end

  def gallery
    concat( render :partial => 'pictures/gallery' )
    nil
  end

end
