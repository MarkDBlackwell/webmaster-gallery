require 'test_helper'

class ThumbnailPicturesPartialTest < SharedPicturesPartialTest

  test "alert me if Rails enables these semantics" do
    assert_template 'pictures/_thumbnail', 0
    assert_template({:partial => 'pictures/_thumbnail'}, 0)
    assert_select '[alt=?]', {:text => 'two-title'}, 0
    assert_select '[alt=?]', {:text => 'two-title', :count => 1}, 0
# These work:
#    assert_template :partial => 'pictures/_thumbnail', :count => 1
#    assert_select 'div.thumbnail', 1
#    assert_select '[alt=?]', 'two-title', 1
#    assert_select '[src=?]', filename_matcher('two-t.png'), 1
  end

  test "should render" do
    assert_template :partial => 'pictures/_thumbnail', :count => 1
  end

  test "there should be a single thumbnail div" do
    assert_select 'div.thumbnail', 1
  end

  test "there should be a single anchor, which should link to the right "\
       "picture" do
    assert_select 'div.thumbnail > a', 1
    assert_select 'a', 1 do
      assert_select '[href=?]', filename_matcher('two.png')
    end
  end

  test "there should be a single image, which should have the right thumbnail "\
       "filename source and the right title as alt-text" do
    assert_select 'div.thumbnail > a > img', 1
    assert_select 'img', 1 do
      assert_select '[src=?]', filename_matcher('two-t.png')
      assert_select '[alt=?]', 'two-title'
    end
  end

#-------------
  private

  def setup
    picture=pictures(:two)
    render :partial => 'pictures/thumbnail', :locals => {:picture => picture}
  end

end
