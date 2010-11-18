require 'test_helper'

class ThumbnailPicturesPartialTest < ActionView::TestCase
  include PicturesPartialTestShared

  test "should render" do
    assert_template :partial => 'pictures/_thumbnail'
  end

  test "should include one thumbnail div" do
    assert_select 'div.thumbnail', 1
  end

  test "should render an image within a thumbnail" do 
    assert_select 'div.thumbnail > * > img'
  end

  test "rendered image should have the right thumbnail filename" do
    assert_select '[src=?]', filename_matcher('two-t.png')
  end

  test "rendered image should have the right title as alt-text" do
    assert_select '[alt=?]', 'two-title'
  end

  test "should render an anchor within a thumbnail" do 
    assert_select 'div.thumbnail > a'
  end

  test "should render an image within an anchor" do 
    assert_select 'a > img'
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
