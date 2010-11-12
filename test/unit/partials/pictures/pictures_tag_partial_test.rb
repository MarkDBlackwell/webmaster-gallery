require 'test_helper'

class PicturesTagPartialTest < ActionView::TestCase

#-------------
# Find method tests:

  test "should include this file" do
#    flunk
  end

  test "should render" do
    tag=Tag.find(:first)
    render :partial => 'pictures/tag', :locals => {:tag => tag}
    assert_template :partial => 'pictures/_tag'
  end

end
