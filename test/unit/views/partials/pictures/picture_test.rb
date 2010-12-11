require 'test_helper'

class PicturePicturesPartialTest < SharedPartialTest

#TODO: possibly use http://github.com/justinfrench/formtastic

  %w[description sequence title weight].each do |unique|
    test "should render a single, right #{unique} within a picture" do
      has_one "div.picture > form > div.field > div.#{unique}", "two-#{unique}"
    end
  end

  test "should render pretty html source" do
    setup{@edit_fields=@editable=@show_filename=true}
    check_pretty_html_source nil, %w[edit  field  picture  thumbnail ],
        'form accept'
  end

  test "if show filename..." do
# Should render a single, right filename within a picture:
    has_one('div.picture > form > div.field > div.filename',
        'two.png'){@show_filename=true}
  end

  test "if editable..." do
    assert_select (s1='div.picture > div.edit'), false
    assert_select (s2=s1+' > form.button_to'), false
    assert_select (s3=s2+'[method]'), false
    setup{@editable=true}
# Should render a single edit div within a picture:
    assert_select s1, 1
# Should render a single button within an edit div:
    assert_select s2, 1
# Rendered button within an edit div should have method get:
    assert_select s3, 1
    assert_select s2+'[method=?]', 'get'
  end

  test "happy path..." do
# Should render:
    assert_partial
# Should include one picture div:
    assert_select (s1='div.picture'), 1
# Should render a single, right picture:
    assert_select s1+'[id]', 1
    assert_select (s2="[id=picture_#{@picture.id}]"), 1
    assert_select s1+s2, 1
# Should render a single thumbnail within a picture:
    assert_select (s3=s1+' > form > div.') + 'thumbnail', 1
# Should render a single, right year within a picture:
    has_one s3+'field > div.year', '2002'
  end

#-------------
  private

  def setup(&block)
    controller_yield &block
    @picture=pictures :two
    render_partial 'pictures/picture', :picture => @picture
  end

end
