require 'test_helper'
should_include_this_file

class PicturesThumbnailPartialTest < ActionView::TestCase

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
