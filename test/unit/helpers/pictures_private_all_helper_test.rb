module PicturesPrivateAllHelperTest

  private

  def all_pictures
    @pictures = Picture.find(:all)
    gallery
  end

  def all_tags
    @all_tags = Tag.find(:all)
    tags
  end

end
