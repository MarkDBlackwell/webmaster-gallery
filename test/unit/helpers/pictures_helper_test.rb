require 'test_helper'

class PicturesHelperTest < ActionView::TestCase

#-------------
# Gallery helper tests:

  test "gallery helper should render gallery partial" do
    @pictures = Picture.find(:all)
    gallery
    see_output
    assert_select 'div.gallery'
  end

#-------------
# Tags helper tests:

  test "tags helper should render tags partial" do
    assert Date::today < Date::new(2010,11,2), 'Test unwritten.'
  end

#-------------
  private

# Copy this line into a test, if desired:
#    see_output

  def see_output
    f=File.new("#{Rails.root}"\
      '/out/see-output','w')
    f.print rendered
    f.close
  end

end
