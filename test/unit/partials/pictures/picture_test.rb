require 'test_helper'

class PicturesPicturePartialTest < ActionView::TestCase

  test "should include this file" do
#    flunk
  end

  test "should render" do
    assert_template :partial => 'pictures/_picture'
  end

  test "should render a single picture" do
    assert_select 'div.picture', 1
  end

  test "should render the right picture" do
    assert_select "div.picture[id=picture_#{@picture.id}]"
  end

#-------------
  private

  def setup
    @picture=pictures(:two)
    render :partial => 'pictures/picture', :locals => {:picture => @picture}
  end

end
