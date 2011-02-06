require 'test_helper'

class PicturePicturesPartialTest < SharedPicturesPartialTest
# %%vi%%part%%pic%%pic

# TODO: possibly use http://github.com/justinfrench/formtastic

  test "happy path should render..." do
# The right partial, once:
    assert_partial
# A single, right picture:
    assert_single [@dp,'id'], 'picture_'+@picture.id.to_s
# With...:
# Single divs for...:
# Complex picture parts:
    complex = %w[ tags thumbnail ]
    complex.each{|e| assert_select @pd.css_class(e), 1}
# Non-automatic attributes:
    automatic = %w[ id ] + %w[ cre  upd ].map{|e| e+'ated_at'}
    attributes=@picture.attributes.keys
    (attributes-automatic).each{|e| assert_select @fi.css_class(e), 1}
# And...:
# The right tags:
    assert_select @pd.css_class('tags'), (@picture.tags.map(&:name).join "\n")
# The right thumbnail:
    assert_single [@pd.css_class('thumbnail').child('a'),'href'],
        "/images/gallery/#{@picture.filename}", false
# With the thumbnail partial:
    assert_template :partial => 'pictures/_thumbnail', :count => @render_count
# Regarding edit_allowed...:
# If it is not...:
    reset_flags
# No edit div:
    @de=@dp.child(@d).css_class 'edit'
    @fb=@de.child(@f).css_class 'button_to'
    assert_select @de, false
    assert_select @fb, false
# If it is...:
    setup{@edit_allowed=true} # Switch.
# A single edit div...:
    assert_select @de, 1
# Containing a single button...:
# With method, GET:
    assert_single [@fb,@m], 'get'
# And...:
# Regarding editing...:
# If we are not...:
    reset_flags
# No editing form:
    @df=@dp.child @f
    assert_select @df, false
# Tags are rendered with the partial for...:
# Tags:
    assert_template :partial => 'pictures/_tags', :count => @render_count
# Not a field:
    field_count=(attributes-automatic).length
# Rails bug (testing partial locals): see test/unit/views/_test.rb.
    assert_template :partial => 'pictures/_field', :count =>
        @render_count*field_count
# If we are...:
    setup{@editing=true} # Switch.
# A single editing form, with...:
    assert_select @df, 1
# A single, submit-type input:
    @di=@df.child 'input'
    assert_single [@di,'type'], :submit, false
    assert_single [@di,'name'], :commit, false
    assert_single [@di,'value'], 'Save changes', false
# A single, right...:
# Action url:
    assert_single [@df,'action'], (url_for :controller => :admin_pictures,
        :action => :show, :id => @picture.id)
# Http method:
    assert_single [@df,@m], :post
# Tags are rendered with the partial for...:
# A field:
    assert_template :partial => 'pictures/_field', :count =>
        @render_count*field_count + 1
# Not tags:
    assert_template :partial => 'pictures/_tags', :count => @render_count - 1
# And...:
# Pretty html source:
## The @use_controller flag makes no difference.
    setup{@editing=@edit_allowed=@show_filename=true}
    check_pretty_html_source nil, %w[edit  field  picture  thumbnail ],
        'form accept'
  end

#-------------
  private

  def reset_flags
    setup{@editing=@edit_allowed=@show_filename=nil}
  end

  def setup(&block)
    @render_count ||= 0; @render_count += 1
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
