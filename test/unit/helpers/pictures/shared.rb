class SharedPicturesHelperTest < ActionView::TestCase

  private

  def render_all_pictures
# pictures(:all) did not work.
    @pictures = Picture.find(:all)
    gallery
  end

  def render_all_tags
    @all_tags = Tag.find(:all)
    alltags
  end

end
