require 'test_helper'
should_include_this_file

class PicturesPicturePartialTest < ActionView::TestCase

  test "should render" do
    assert_template :partial => 'pictures/_picture'
  end

  test "should include one picture div" do
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
