require 'test_helper'
should_include_this_file

class PicturesPicturePartialTest < ActionView::TestCase
  include PartialTestShared

  test "should render" do
    assert_template :partial => 'pictures/_picture'
  end

  test "should include one picture div" do
    assert_select 'div.picture', 1
  end

  test "should render the right picture" do
    assert_select "div.picture[id=picture_#{@picture.id}]"
  end

  test "should render a description within a picture" do
    assert_select 'div.picture > form > div.field > div.description'
  end

  test "should render the right description" do
    assert_select 'div.picture > form > div.field > div.description', 'two-description'
  end

  test "should render a file name within a picture" do
    assert_select 'div.picture > form > div.field > div.filename'
  end

  test "should render a sequence within a picture" do
    assert_select 'div.picture > form > div.field > div.sequence'
  end

  test "should render a thumbnail within a picture" do
    assert_select 'div.picture > form > div.thumbnail'
  end

  test "should render a title within a picture" do
    assert_select 'div.picture > form > div.field > div.title'
  end

  test "should render the right title" do
    assert_select 'div.picture > form > div.field > div.title', 'two-title'
  end

  test "should render a weight within a picture" do
    assert_select 'div.picture > form > div.field > div.weight'
  end

  test "should render a year within a picture" do
    assert_select 'div.picture > form > div.field > div.year'
  end

  test "should render the right year" do
    assert_select 'div.picture > form > div.field > div.year', '2002'
  end

  test "should not render an edit div if not editable" do
    assert_select 'div.picture > div.edit', 0
  end

  test "should render an edit div if editable" do
    setup {@editable = true}
    assert_select 'div.picture > div.edit'
  end

  test "should render a button within an edit div if editable" do
    setup {@editable = true}
    assert_select 'div.edit > form.button_to'
  end

  test "rendered button within an edit div should have method get" do
    setup {@editable = true}
    assert_select 'div.edit > form.button_to[method=?]', 'get'
  end

#-------------
  private

  def setup(&block)
    controller_yield &block
    @picture=pictures(:two)
    render :partial => 'pictures/picture', :locals => {:picture => @picture}
  end

end
