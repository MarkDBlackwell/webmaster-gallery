require 'test_helper'

class PicturesThumbnailPartialTest < ActionView::TestCase

#-------------
# Find method tests:

  test "should include this file" do
#    flunk
  end

  test "should render" do
    picture=pictures(:two)
    render :partial => 'pictures/thumbnail', :locals => {:picture => picture}
    assert_template :partial => 'pictures/_thumbnail'
  end

end
