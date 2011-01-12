require 'test_helper'

class PicturePicturesPartialTest < SharedPartialTest

# TODO: possibly use http://github.com/justinfrench/formtastic

  test "happy path should render..." do
# The right partial, once:
    assert_partial
# A single...:
# Picture div:
    assert_select @dp, 1
# Thumbnail within a picture:
    assert_select @pd.css_class('thumbnail'), 1
# The right...:
# Picture:
    @i='id'
    assert_select @dp.attribute(@i), 1
    @ip=CssString.new.attribute @i, 'picture_'+@picture.id.to_s
    assert_select @dp+@ip, 1
    assert_select @ip, 1
# Within a picture, the right...:
# Year:
    has_one @fi.css_class('year'), '2002'
# Tags:
    assert_select @pd.css_class('tags'), 1
  end

  %w[description sequence title weight].each do |unique|
    u=unique
    test "should render a single, right #{u} within a picture" do
      has_one @fi.css_class(u), "two-#{u}"
    end
  end

  test "should render pretty html source" do
    setup{@edit_fields=@editable=@show_filename=true}
    check_pretty_html_source nil, %w[edit  field  picture  thumbnail ],
        'form accept'
  end

  test "when editing fields..." do
    @df=@dp.child @f

    @fa,@fm=['action',@m].map{|e| @df.attribute e}
    @aq,@mq=['action',@m].map{|e| @df.attribute e, '?'}

    assert_select @df, false
    setup{@edit_fields=true} # Switch.
# Should render a single editing form...:
    assert_select @df, 1
# Which should have a single, right...:
# Action url:
    assert_select @fa, 1
    assert_select @aq, (url_for :controller => @use_controller, :action =>
        :show, :id => @picture.id)
# Http method:
    assert_select @fm, 1
    assert_select @mq, :post
  end

  test "if editable, should render a single..." do
    @de=@dp.child(@d).css_class 'edit'
    @fb=@de.child(@f).css_class 'button_to'
    @bm=@fb.attribute @m
    assert_select @de, false
    assert_select @fb, false
    assert_select @bm, false
    setup{@editable=true} # Switch.
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
    @use_controller=:admin_pictures
    @picture=pictures :two
    render_partial 'pictures/picture', :picture => @picture
    @m='method'
    @d,@f = %w[div form].map{|e| CssString.new e}
    @dp=@d.css_class 'picture'
    @pd=@dp.child @d
    @fi=@pd.css_class('field').child @d
  end

end
