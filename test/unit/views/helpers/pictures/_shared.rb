class SharedPicturesHelperTest < SharedViewTest
# %%vi%%he%%pic

  tests PicturesHelper

  private

  def render_all_pictures
    @pictures=Picture.find :all
    gallery
  end

  def render_all_tags
    @all_tags=Tag.find :all
    alltags
  end

end
