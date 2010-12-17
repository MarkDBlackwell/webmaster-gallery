require 'test_helper'

class PicturePicturesPartialTest < SharedPartialTest

#TODO: possibly use http://github.com/justinfrench/formtastic

  test "happy path should render..." do
# The right partial, once:
    assert_partial
# A single...:
# Picture div:
    assert_select @dp, 1
# Thumbnail within a picture:
    assert_select @fd.css_class('thumbnail'), 1
# Right...:
# Picture:
    assert_select @dp.attribute('id'), 1
    assert_select @ip, 1
    assert_select @dp+@ip, 1
# Year within a picture:
    has_one @fi.css_class('year'), '2002'
  end

  %w[description sequence title weight].each do |unique|
    test "should render a single, right #{unique} within a picture" do
      has_one @fi.css_class(unique), "two-#{unique}"
    end
  end

  test "should render pretty html source" do
    setup{@edit_fields=@editable=@show_filename=true}
    check_pretty_html_source nil, %w[edit  field  picture  thumbnail ],
        'form accept'
  end

  test "if show filename..." do
# Should render a single, right filename within a picture:
    has_one(@fi.css_class('filename'),'two.png'){@show_filename=true}
  end

  test "if editable, should render a single..." do
    assert_select @de, false # See below.
    assert_select @fb, false
    assert_select @bm, false
    setup{@editable=true}
# Edit div within a picture:
    assert_select @de, 1
# Button within an edit div...:
    assert_select @fb, 1
# Which should have method get:
    assert_select @bm, 1
    assert_select @fb.attribute(@m,'?'), 'get'
  end

#-------------
  private

  def setup(&block)
    controller_yield &block
    @picture=pictures :two
    render_partial 'pictures/picture', :picture => @picture
    @d, @m = %w[div  method].map{|e| CssString.new e}
    @ip=CssString.new().attribute 'id', 'picture_'+@picture.id.to_s
    @dp=@d.css_class 'picture'
    @de=@dp.child(@d).css_class 'edit'
    @fd=@dp.child 'form', @d
    @fi=@fd.css_class('field').child @d
    @fb=@de.child('form').css_class 'button_to'
    @bm=@fb.attribute @m
  end

end
