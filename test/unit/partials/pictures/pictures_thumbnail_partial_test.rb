require 'test_helper'

class PicturesThumbnailPartialTest < ActionView::TestCase

  test "should include this file" do
#    flunk
  end

  test "should render" do
    assert_template :partial => 'pictures/_thumbnail'
  end

#-------------
  private

  def setup
    picture=pictures(:two)
    render :partial => 'pictures/thumbnail', :locals => {:picture => picture}
  end

end
