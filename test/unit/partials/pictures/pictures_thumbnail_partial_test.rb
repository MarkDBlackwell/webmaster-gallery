require 'test_helper'

class PicturesThumbnailPartialTest < ActionView::TestCase

#-------------
# Find method tests:

  test "should include this file" do
#    flunk
  end

  test "should render" do
#    @picture=Picture.find(:all).first
    a=[:partial => 'pictures/thumbnail', :locals => {:picture => nil}]
    render *a
    assert_template *a
  end

end
