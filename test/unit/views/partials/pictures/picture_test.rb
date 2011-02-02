require 'test_helper'

class PicturePicturesPartialTest < SharedPicturesPartialTest
# %%vi%%part%%pic%%pic

# TODO: possibly use http://github.com/justinfrench/formtastic

# working on

  test "happy path should render..." do
# The right partial, once:
    assert_partial
# A single, right picture:
    assert_single [@dp,'id'], 'picture_'+@picture.id.to_s
# With...:
    attributes=@picture.attributes.keys
    automatic = %w[ id ] + %w[ cre  upd ].map{|e| e+'ated_at'}
# The single, right value of visible attributes:
    hidden = %w[ filename ]
    (attributes-automatic-hidden).each do |e|
      assert_single @fi.css_class(e), @picture[e]
    end
# Single divs for...:
# Non-automatic attributes:
    (attributes-automatic).each do |e|
      assert_select @fi.css_class(e), 1
    end
# Complex picture parts:
    complex = %w[ tags thumbnail ]
    complex.each do |e|
      assert_select @pd.css_class(e), 1
    end
# The right tags:
    assert_select @pd.css_class('tags'), (@picture.tags.map(&:name).join "\n")
# The right thumbnail:
    assert_single [@pd.css_class('thumbnail').child('a'),'href'],
        "/images/gallery/#{@picture.filename}", false
# And...:
# Should render pretty html source:
    setup{@edit_fields=@editable=@show_filename=true}
    check_pretty_html_source nil, %w[edit  field  picture  thumbnail ],
        'form accept'
## The @use_controller flag makes no difference.
# And...:
# Within a picture, should render...:
    @df=@dp.child @f
# If not editing fields...:
    reset_flags
# No editing form:
    assert_select @df, false
# If editing fields...:
    setup{@edit_fields=true} # Switch.
# A single editing form, with a single, right...:
# Action url:
    assert_single [@df,'action'], (url_for :controller => :admin_pictures,
        :action => :show, :id => @picture.id)
# Http method:
    assert_single [@df,@m], :post
# And...:
# Within a picture, should render...:
    @de=@dp.child(@d).css_class 'edit'
    @fb=@de.child(@f).css_class 'button_to'
# If not editable...:
    reset_flags
# No edit div:
    assert_select @de, false
    assert_select @fb, false
# If editable...:
    setup{@editable=true} # Switch.
# A single edit div...:
    assert_select @de, 1
# Containing a single button...:
# With method, GET:
    assert_single [@fb,@m], 'get'
## TODO: # Going to admin:
# Within a filename div, should render...:
    f='filename'
    ff=@fi.css_class f
# If not showing filename...:
    reset_flags
# Nothing:
    assert_select ff, ''
# If showing filename...:
    setup{@show_filename=true} # Switch.
# A single, right filename...:
    assert_single ff, @picture[f], false
  end

#-------------
  private

  def reset_flags
    setup{@edit_fields=@editable=@show_filename=nil}
  end

  def setup(&block)
    @controller.default_url_options={:controller=>:pictures}
    p=@picture=(pictures :two)
    %w[sequence weight].each{|e| p[e]='two-'+e}
    controller_yield &block
    render_partial 'pictures/picture', :picture => p
    @m='method'
    @d,@f = %w[div form].map{|e| CssString.new e}
    @dp=@d.css_class 'picture'
    @pd=@dp.child @d
    @fi=@pd.css_class('field').child @d
  end

end
