require 'test_helper'
should_include_this_file

class PicturesGalleryPartialTest < ActionView::TestCase
  helper PicturesHelper

  test "should render" do
    render_all_pictures
    assert_template :partial => 'pictures/_gallery'
  end

  test "should include one gallery div" do
    render_all_pictures
    assert_select 'div.gallery', 1
  end

  test "should render a picture within a gallery" do
    render_all_pictures
    assert_select 'div.gallery > div.picture'
  end

  test "should render all the pictures" do
    render_all_pictures
    assert_select 'div.gallery > div.picture', 2
  end

  test "should render a title within a picture" do
    render_all_pictures
    assert_select 'div.picture > form > div.field > div.title'
  end

  test "should render a description within a picture" do
    render_all_pictures
    assert_select 'div.picture > form > div.field > div.description'
  end

  test "should render a year within a picture" do
    render_all_pictures
    assert_select 'div.picture > form > div.field > div.year'
  end

  test "should render a thumbnail within a picture" do
    render_all_pictures
    assert_select 'div.picture > form > div.thumbnail'
  end

  test "should render an image within a thumbnail" do 
    render_all_pictures
    assert_select 'div.thumbnail > * > img'
  end

  test "rendered image should have the right thumbnail filename" do
    picture_two
    assert_select '[src=?]', filename_matcher('two-t.png')
  end

  test "should render the right year" do
    picture_two
    assert_select 'div.picture > form > div.field > div.year', '2002'
  end

  test "should render the right description" do
    picture_two
    assert_select 'div.picture > form > div.field > div.description', 'two-description'
  end

  test "should render the right title" do
    picture_two
    assert_select 'div.picture > form > div.field > div.title', 'two-title'
  end

  test "rendered image should have the right title as alt-text" do
    picture_two
    assert_select '[alt=?]', 'two-title'
  end

  test "should render an anchor within a thumbnail" do 
    render_all_pictures
    assert_select 'div.thumbnail > a'
  end

  test "should render an image within an anchor" do 
    render_all_pictures
    assert_select 'a > img'
  end

  test "rendered thumbnail anchor should be a link" do
    render_all_pictures
    assert_select 'div.thumbnail > a[href]'
  end

  test "should render a link to the right picture" do
    picture_two
    assert_select '[href=?]', filename_matcher('two.png')
  end

  test "should not render an edit div if not editable" do
    render_all_pictures
    assert_select 'div.picture > div.edit', 0
  end

  test "should render an edit div if editable" do
    @editable = true
    render_all_pictures
    assert_select 'div.picture > div.edit'
  end

  test "should render a button within an edit div if editable" do
    @editable = true
    render_all_pictures
    assert_select 'div.edit > form.button_to'
  end

  test "rendered button within an edit div should have method get" do
    @editable = true
    render_all_pictures
    assert_select 'div.edit > form.button_to[method=?]', 'get'
  end

#-------------
  private

  def filename_matcher(s)
#    %r@^/images/gallery/#{s}\?\d+$@
    %r:^/images/gallery/#{s}\?\d+$:
  end

  def picture_two
    pictures(:one).destroy
    @pictures = Picture.find(:all)
    render :partial => 'pictures/gallery'
  end

  def render_all_pictures
    @pictures = Picture.find(:all)
    render :partial => 'pictures/gallery'
  end

end
