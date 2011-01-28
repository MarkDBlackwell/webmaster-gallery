class SharedPicturesHelperTest < SharedViewTest
# %%vi%%he%%pic

  tests PicturesHelper

  private

  def render_all_pictures
    @pictures=Picture.all
    gallery
  end

  def render_all_tags
    @all_tags=Tag.all
    alltags
  end

end
