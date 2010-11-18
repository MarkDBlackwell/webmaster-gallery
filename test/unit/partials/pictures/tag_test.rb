require 'test_helper'

class TagPicturesPartialTest < ActionView::TestCase

  test "should render" do
    assert_template :partial => 'pictures/_tag'
  end

  test "should include one tag div" do
    assert_select 'div.tag', 1
  end

#-------------
  private

  def setup
    tag=Tag.find(:first) # Using 'tags(:two)' did not call the right method.
    render :partial => 'pictures/tag', :locals => {:tag => tag}
  end

end
