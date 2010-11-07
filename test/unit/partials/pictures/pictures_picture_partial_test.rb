require 'test_helper'

class PicturesPicturePartialTest < ActionView::TestCase

#-------------
# Find method tests:

  test "should include this file" do
#    flunk
  end

  test "should render partial" do
    @picture=pictures(:two)
    render :partial => 'pictures/picture', :locals => {:picture => @picture}
  end

  test "should render a single picture" do
    @picture=pictures(:two)
    render :partial => 'pictures/picture', :locals => {:picture => @picture}
    assert_select 'div.picture', 1
  end

  test "should render the right picture" do
    @picture=pictures(:two)
    render :partial => 'pictures/picture', :locals => {:picture => @picture}
    assert_select "div.picture[id=picture_#{@picture.id}]"
  end

end
