require 'test_helper'

class PicturePicturesPartialTest < SharedPicturesPartialTest
# %%vi%%part%%pic%%pic

# TODO: possibly use http://github.com/justinfrench/formtastic

  test "happy path should render..." do
# The right partial, once:
    assert_partial
# A single, right picture:
    assert_single [@dp,'id'], 'picture_'+@picture.id.to_s
# And within it, the right...:
# Thumbnail:
    assert_select @pd.css_class('thumbnail'), 1
# Year:
    assert_single @fi.css_class('year'), '2002'
# Tags:
    assert_select @fi.css_class('tags'), 1
  end

  %w[description sequence title weight].each do |u| # Unique
    test "should render a single, right #{u} within a picture" do
      assert_single @fi.css_class(u), "two-#{u}"
    end
  end

  test "should render pretty html source" do
    setup{@edit_fields=@editable=@show_filename=true}
    check_pretty_html_source nil, %w[edit  field  picture  thumbnail ],
        'form accept'
  end

  test "when editing fields..." do
    @df=@dp.child @f
    assert_select @df, false
    setup{@edit_fields=true} # Switch.
# Should render a single editing form, with a single, right...:
# Action url:
    assert_single [@df,'action'], (url_for :controller => @use_controller,
        :action => :show, :id => @picture.id)
# Http method:
    assert_single [@df,@m], :post
  end

  test "if editable, should render a single..." do
    @de=@dp.child(@d).css_class 'edit'
    @fb=@de.child(@f).css_class 'button_to'
    assert_select @de, false
    assert_select @fb, false
    setup{@editable=true} # Switch.
# Edit div within a picture:
    assert_select @de, 1
# And within it, a single button with method, GET:
    assert_single [@fb,@m], 'get'
  end

#-------------
  private

  def setup(&block)
    controller_yield &block
    @use_controller=:admin_pictures
    p=@picture=(pictures :two)
    %w[sequence weight].each{|e| p[e]='two-'+e}
    render_partial 'pictures/picture', :picture => p
    @m='method'
    @d,@f = %w[div form].map{|e| CssString.new e}
    @dp=@d.css_class 'picture'
    @pd=@dp.child @d
    @fi=@pd.css_class('field').child @d
  end

end
