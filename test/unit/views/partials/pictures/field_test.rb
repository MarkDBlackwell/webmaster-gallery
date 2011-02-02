require 'test_helper'

class FieldPicturesPartialTest < SharedPicturesPartialTest
# %%vi%%part%%pic%%fie

# working on

  test "happy path should render..." do
# Pretty html source:
    check_pretty_html_source nil, 'field'
# The right partial, once:
    assert_partial
# One field div:
    assert_select @df, 1
# Div for field:
    assert_select @dt, 1
# A model attribute:
    assert_single @dft, @field
  end

  test "if edit fields..." do
    s=@dft.child 'input'
    assert_select s, false
    setup{@edit_fields=true}
# Should render a single, empty input:
    assert_single s, ''
    assert_single [s,'name'], 'picture[title]'
    assert_single [s,'type'], 'text'
    assert_single [s,'value'], @field
  end

  test "if show filename..." do
    s=@df.child @dn
    assert_select s, false
    setup(:filename){@show_filename=true}
# Should render a single, right filename:
    assert_single s, @field
  end

  test "if show labels..." do
    s=@dft.child @dl
    assert_select s, false
    setup{@show_labels=true}
# Should render a single, right label:
    assert_single s, '&nbsp; title'
  end

#-------------
  private

  def setup(field=:title,&block)
# Naming this method, 'render', then using 'super', failed somehow.
    controller_yield &block
    c=:pictures
    @controller.default_url_options={:controller=>c}
    record=Picture.new
    record[field]=(@field='some_value')
    render_partial 'pictures/field', :record => record, :field => field
    @df,@dl,@dn,@dt = %w[ field label filename title ].
        map{|e| CssString.new('div').css_class e}
    @dft=@df.child @dt
  end

end
