require 'test_helper'

class PicturesTagPartialTest < ActionView::TestCase

#-------------
# Find method tests:

  test "should include this file" do
#    flunk
  end

  test "should render" do
    a[:partial => 'pictures/tag', :locals => {:tag => nil}]
    render *a
    assert_template *a
  end

end
