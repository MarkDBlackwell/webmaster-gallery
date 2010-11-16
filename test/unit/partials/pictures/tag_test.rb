require 'test_helper'
should_include_this_file

class PicturesTagPartialTest < ActionView::TestCase

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
