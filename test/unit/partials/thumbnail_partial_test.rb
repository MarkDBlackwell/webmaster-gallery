require 'test_helper'

class ThumbnailPartialTest < ActionView::TestCase

#-------------
# Find method tests:

  test "should include this file" do
#    flunk
  end

  test "should render partial" do
    @picture=Picture.find(:all).first
    render :partial => 'pictures/thumbnail', :locals => {:picture => @picture}
#    assert false
  end

end
