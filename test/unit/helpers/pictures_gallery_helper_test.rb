require 'test_helper'

class PicturesHelperTest < ActionView::TestCase
  include PicturesPrivateAllHelperTest

  test "rake should include this gallery file" do
#    flunk
  end

  test "should render gallery partial" do
    assert Date::today < Date::new(2010,11,2), 'Test unwritten.'
  end

  test "should render a gallery" do
    gallery
    assert_select 'div.gallery'
  end

  test "should render a picture within a gallery" do
    all_pictures
    assert_select 'div.gallery > div.picture'
  end

  test "should render all the pictures" do
    all_pictures
    assert_select 'div.gallery > div.picture', 2
  end

  test "should render a title within a picture" do
    all_pictures
    assert_select 'div.picture > div.title'
  end

  test "should render a description within a picture" do
    all_pictures
    assert_select 'div.picture > div.description'
  end

  test "should render a year within a picture" do
    all_pictures
    assert_select 'div.picture > div.year'
  end

  test "should render a thumbnail within a picture" do
    all_pictures
    assert_select 'div.picture > div.thumbnail'
  end

  test "should render an image within a thumbnail" do 
    all_pictures
    assert_select 'div.thumbnail > * > img'
  end

  test "rendered image should have the right thumbnail filename" do
    picture_two
    assert_select '[src=?]', filename_matcher('two-t.png')
  end

  test "should render the right year" do
    picture_two
    assert_select 'div.picture > div.year', 'two-year'
  end

  test "should render the right description" do
    picture_two
    assert_select 'div.picture > div.description', 'two-description'
  end

  test "should render the right title" do
    picture_two
    assert_select 'div.picture > div.title', 'two-title'
  end

  test "rendered image should have the right title as alt-text" do
    picture_two
    assert_select '[alt=?]', 'two-title'
  end

  test "should render an anchor within a thumbnail" do 
    all_pictures
    assert_select 'div.thumbnail > a'
  end

  test "should render an image within an anchor" do 
    all_pictures
    assert_select 'a > img'
  end

  test "rendered thumbnail anchor should be a link" do
    all_pictures
    assert_select 'div.thumbnail > a[href]'
  end

  test "should render a link to the right picture" do
    picture_two
    assert_select '[href=?]', filename_matcher('two.png')
  end

  test "should not render an edit div if not editable" do
    all_pictures
    assert_select 'div.picture > div.edit', 0
  end

  test "should render an edit div if editable" do
    @editable = true
    all_pictures
    assert_select 'div.picture > div.edit'
  end

  test "should render a button within an edit div if editable" do
    @editable = true
    all_pictures
    assert_select 'div.edit > form.button_to'
  end

  test "rendered button within an edit div should have method get" do
    @editable = true
    all_pictures
    assert_select 'div.edit > form.button_to[method=?]', 'get'
  end

end
