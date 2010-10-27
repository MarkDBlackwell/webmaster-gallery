require 'test_helper'

class PicturesHelperTest < ActionView::TestCase

#-------------
# All helpers tests:

  test "rake should include this file" do
    flunk
  end

  test "all helpers should render pretty html source" do
    all_tags
    all_pictures
    divs = %w[all-tags tag gallery picture thumbnail title description year]
    s = "<div class=\"#{Regexp.union *divs}\""
# Remove any of these divs which are at line beginnings:
    altered = rendered.gsub( Regexp.new("\n" + s),"\n")
    s2 = altered.clone
# Should not be able to find any of those divs:
    assert_equal true, altered.gsub!(Regexp.new(s),'').nil?, s2
  end

#-------------
# Gallery helper tests:

  test "gallery helper should render gallery partial" do
    assert Date::today < Date::new(2010,11,2), 'Test unwritten.'
  end

  test "gallery helper should render a gallery" do
    gallery
    assert_select 'div.gallery'
  end

  test "gallery helper should render a picture within a gallery" do
    all_pictures
    assert_select 'div.gallery > div.picture'
  end

  test "gallery helper should render all the pictures" do
    all_pictures
    assert_select 'div.gallery > div.picture', 2
  end

  test "gallery helper should render a title within a picture" do
    all_pictures
    assert_select 'div.picture > div.title'
  end

  test "gallery helper should render a description within a picture" do
    all_pictures
    assert_select 'div.picture > div.description'
  end

  test "gallery helper should render a year within a picture" do
    all_pictures
    assert_select 'div.picture > div.year'
  end

  test "gallery helper should render a thumbnail within a picture" do
    all_pictures
    assert_select 'div.picture > div.thumbnail'
  end

  test "gallery helper should render an image within a thumbnail" do 
    all_pictures
    assert_select 'div.thumbnail > * > img'
  end

  test "gallery helper rendered image should have the right thumbnail filename" do
    picture_two
    assert_select '[src=?]', filename_matcher('two-t.png')
  end

  test "gallery helper should render the right year" do
    picture_two
    assert_select 'div.picture > div.year', 'two-year'
  end

  test "gallery helper should render the right description" do
    picture_two
    assert_select 'div.picture > div.description', 'two-description'
  end

  test "gallery helper should render the right title" do
    picture_two
    assert_select 'div.picture > div.title', 'two-title'
  end

  test "gallery helper rendered image should have the right title as alt-text" do
    picture_two
    assert_select '[alt=?]', 'two-title'
  end

  test "gallery helper should render an anchor within a thumbnail" do 
    all_pictures
    assert_select 'div.thumbnail > a'
  end

  test "gallery helper should render an image within an anchor" do 
    all_pictures
    assert_select 'a > img'
  end

  test "gallery helper rendered thumbnail anchor should be a link" do
    all_pictures
    assert_select 'div.thumbnail > a[href]'
  end

  test "gallery helper should render a link to the right picture" do
    picture_two
    assert_select '[href=?]', filename_matcher('two.png')
  end

  test "gallery helper should not render an edit div if not editable" do
    all_pictures
    assert_select 'div.picture > div.edit', 0
  end

  test "gallery helper should render an edit div if editable" do
    @editable = true
    all_pictures
    assert_select 'div.picture > div.edit'
  end

  test "gallery helper should render a button within an edit div if editable" do
    @editable = true
    all_pictures
    assert_select 'div.edit > form.button_to'
  end

  test "gallery helper rendered button within an edit div should have method get" do
    @editable = true
    all_pictures
    assert_select 'div.edit > form.button_to[method=?]', 'get'
  end

#-------------
# Tags helper tests:

  test "tags helper should render tags partial" do
    assert Date::today < Date::new(2010,11,2), 'Test unwritten.'
  end

  test "tags helper should render a list of all tags" do
    all_tags
    assert_select 'div.all-tags'
  end

  test "tags helper should render a tag within a list of all tags" do
    all_tags
    assert_select 'div.all-tags > div.tag'
  end

  test "tags helper should render the right tag name" do
    tag_two
    assert_select 'div.all-tags > div.tag', 'two-name'
  end

#-------------
  private

  def filename_matcher(s)
    %r@^/images/gallery/#{s}\?\d+$@
  end

  def all_pictures
    @pictures = Picture.find(:all)
    gallery
  end

  def all_tags
    @all_tags = Tag.find(:all)
    tags
  end

  def picture_two
    @pictures = Picture.find(:all)
    pictures(:one).destroy
    gallery
  end

# Copy this line into a test, if desired:
#    see_output

  def see_output
    f=File.new("#{Rails.root}"\
      '/out/see-output','w')
    f.print rendered
    f.close
  end

  def tag_two
# Didn't seem to invoke the ActiveRecord test method, tags:
# ArgumentError: wrong number of arguments (1 for 0)
#    tags(:one).destroy
    @all_tags = Tag.find :all, :conditions => ["name = ?", 'two-name']
    tags
  end

end
