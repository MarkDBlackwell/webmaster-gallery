module PicturesPrivateAllHelperTest

  private

  def render_all_pictures
    @pictures = Picture.find(:all) # pictures(:all) did not work.
    gallery
  end

  def render_all_tags
    @all_tags = Tag.find(:all)
    alltags
  end

end
