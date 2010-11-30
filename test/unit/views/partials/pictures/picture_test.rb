require 'test_helper'

class PicturePicturesPartialTest < SharedPartialTest

#TODO: possibly use http://github.com/justinfrench/formtastic

  test "should render pretty html source" do
    setup {@edit_fields = @editable = @show_filename = true}
    check_pretty_html_source nil, %w[edit field picture thumbnail ],
        'form accept'
  end

  %w[description sequence title weight].each do |unique|
    test "should render a single, right #{unique} within a picture" do
      has_one "div.picture > form > div.field > div.#{unique}", "two-#{unique}"
    end
  end

  test "if show filename..." do
# Should render a single, right filename within a picture:
    has_one('div.picture > form > div.field > div.filename',
        'two.png') {@show_filename = true}
  end

  test "if editable..." do
    assert_select 'div.picture > div.edit', false
    assert_select 'div.picture > div.edit > form.button_to', false
    assert_select 'div.picture > div.edit > form.button_to[method]', false
    setup {@editable = true}
# Should render a single edit div within a picture:
    assert_select 'div.picture > div.edit', 1
# Should render a single button within an edit div:
    assert_select 'div.picture > div.edit > form.button_to', 1
# Rendered button within an edit div should have method get:
    assert_select 'div.picture > div.edit > form.button_to[method]', 1
    assert_select 'div.picture > div.edit > form.button_to[method=?]', 'get'
  end

  test "picture partial..." do
# Should render:
    assert_template :partial => 'pictures/_picture', :count => 1
# Should include one picture div:
    assert_select 'div.picture', 1
# Should render a single, right picture:
    assert_select 'div.picture[id]', 1
    assert_select "div.picture[id=picture_#{@picture.id}]", 1
    assert_select "[id=picture_#{@picture.id}]", 1
# Should render a single thumbnail within a picture:
    assert_select 'div.picture > form > div.thumbnail', 1
# Should render a single, right year within a picture:
    has_one 'div.picture > form > div.field > div.year', '2002'
  end

#-------------
  private

  def setup(&block)
    controller_yield &block
    @picture=pictures(:two)
    render :partial => 'pictures/picture', :locals => {:picture => @picture}
  end

end
