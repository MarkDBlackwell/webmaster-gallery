require 'test_helper'

class PicturePicturesPartialTest < SharedPartialTest

#TODO: possibly use http://github.com/justinfrench/formtastic

  test "should render" do
    assert_template :partial => 'pictures/_picture', :count => 1
  end

  test "should include one picture div" do
    assert_select 'div.picture', 1
  end

  test "should render a single, right picture" do
    assert_select 'div.picture[id]', 1
    assert_select "div.picture[id=picture_#{@picture.id}]", 1
    assert_select "[id=picture_#{@picture.id}]", 1
  end

  test "should render a single thumbnail within a picture" do
    assert_select 'div.picture > form > div.thumbnail', 1
  end

  test "should render a single, right year within a picture" do
    has_one 'div.picture > form > div.field > div.year', '2002'
  end

  %w[description sequence title weight].each do |unique|
    test "should render a single, right #{unique} within a picture" do
      has_one "div.picture > form > div.field > div.#{unique}", "two-#{unique}"
    end
  end

  test "should render a single, right filename within a picture if show "\
       "filename" do
    has_one('div.picture > form > div.field > div.filename',
        'two.png') {@show_filename = true}
  end

  test "should render a single edit div within a picture if editable" do
    assert_select 'div.picture > div.edit', false
    setup {@editable = true}
    assert_select 'div.picture > div.edit', 1
  end

  test "should render a single button within an edit div if editable" do
    assert_select 'div.picture > div.edit > form.button_to', false
    setup {@editable = true}
    assert_select 'div.picture > div.edit > form.button_to', 1
  end

  test "rendered button within an edit div should have method get" do
    assert_select 'div.picture > div.edit > form.button_to[method]', false
    setup {@editable = true}
    assert_select 'div.picture > div.edit > form.button_to[method]', 1
    assert_select 'div.picture > div.edit > form.button_to[method=?]', 'get'
  end

#-------------
  private

  def setup(&block)
    controller_yield &block
    @picture=pictures(:two)
    render :partial => 'pictures/picture', :locals => {:picture => @picture}
  end

end
