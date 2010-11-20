require 'test_helper'

class PicturePicturesPartialTest < SharedPartialTest

  test "should render" do
    assert_template :partial => 'pictures/_picture'
  end

  test "should include one picture div" do
    assert_select 'div.picture', 1
  end

  test "should render a single, right picture" do
    assert_select 'div.picture[id]', 1
    assert_select "div.picture[id=picture_#{@picture.id}]", 1
  end

  test "should render a single, right description within a picture" do
    assert_select 'div.picture > form > div.field > div.description', :text =>
        'two-description', :count => 1
    assert_select_single 'div.picture > form > div.field > div.description',
        'two-description'
  end

  test "should render a single, right filename within a picture if show "\
       "filename" do
    assert_select_single('div.picture > form > div.field > div.filename',
        'two.png') {setup {@show_filename = true}}
  end

  test "should render a single, right sequence within a picture" do
    assert_select 'div.picture > form > div.field > div.sequence', :text =>
        'two-sequence', :count => 1
  end

  test "should render a single thumbnail within a picture" do
    assert_select 'div.picture > form > div.thumbnail', 1
  end

  test "should render a single, right title within a picture" do
    assert_select 'div.picture > form > div.field > div.title', :text =>
        'two-title', :count => 1
  end

  test "should render a single, right weight within a picture" do
    assert_select 'div.picture > form > div.field > div.weight', :text =>
        'two-weight', :count => 1
  end

  test "should render a single, right year within a picture" do
    assert_select 'div.picture > form > div.field > div.year', :text =>
        '2002', :count => 1
  end

  test "should render a single edit div within a picture if editable" do
    assert_select 'div.picture > div.edit', false
    setup {@editable = true}
    assert_select 'div.picture > div.edit', 1
  end

  test "should render a single button within an edit div if editable" do
    assert_select 'div.picture > div.edit > form.button_to', 0
    setup {@editable = true}
    assert_select 'div.picture > div.edit > form.button_to', 1
  end

  test "rendered button within an edit div should have method get" do
    assert_select 'div.edit > form.button_to[method]', 0
    setup {@editable = true}
    assert_select 'div.edit > form.button_to[method]', 1
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
