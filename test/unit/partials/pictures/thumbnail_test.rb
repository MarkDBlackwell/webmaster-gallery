require 'test_helper'

class ThumbnailPicturesPartialTest < SharedPicturesPartialTest

  test "should render" do
    assert_template :partial => 'pictures/_thumbnail'
  end

  test "should include one thumbnail div" do
    assert_select 'div.thumbnail', 1
  end

  test "should render an single image within a thumbnail" do 
    assert_select 'div.thumbnail > * > img', 1
  end

  test "rendered image should have the right thumbnail filename" do
    assert_select '[src=?]', filename_matcher('two-t.png')
  end

  test "rendered image should have once the right title as alt-text" do
# NOTE: Did not work: assert_select '[alt=?]', :text => 'two-title', :count => 1
    assert_select '[alt]', 1
    assert_select '[alt=?]', 'two-title'
  end

  test "should render a single anchor within a thumbnail" do 
    assert_select 'div.thumbnail > a', 1
  end

  test "should render a single image within an anchor" do 
    assert_select 'a > img', 1
  end

  test "rendered thumbnail anchor should be a link" do
    assert_select 'div.thumbnail > a[href]'
  end

  test "should render a link to the right picture" do
    assert_select '[href=?]', filename_matcher('two.png')
  end

#-------------
  private

  def setup
    picture=pictures(:two)
    render :partial => 'pictures/thumbnail', :locals => {:picture => picture}
  end

end
