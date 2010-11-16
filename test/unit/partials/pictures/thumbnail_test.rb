require 'test_helper'
should_include_this_file

class PicturesThumbnailPartialTest < ActionView::TestCase

  test "should render" do
    assert_template :partial => 'pictures/_thumbnail'
  end

  test "should include one thumbnail div" do
    assert_select 'div.thumbnail', 1
  end

#-------------
  private

  def setup
    picture=pictures(:two)
    render :partial => 'pictures/thumbnail', :locals => {:picture => picture}
  end

end
