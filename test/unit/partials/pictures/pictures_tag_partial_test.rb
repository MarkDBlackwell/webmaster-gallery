require 'test_helper'

class PicturesTagPartialTest < ActionView::TestCase

  test "should include this file" do
#    flunk
  end

  test "should render" do
    assert_template :partial => 'pictures/_tag'
  end

#-------------
  private

  def setup
    tag=Tag.find(:first) # Using 'tags(:two)' did not call the right method.
    render :partial => 'pictures/tag', :locals => {:tag => tag}
  end

end
