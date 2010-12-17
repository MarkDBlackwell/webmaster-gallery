require 'test_helper'

class FieldPicturesPartialTest < SharedPartialTest

  test "should render labels" do
    s=@dft.child @dl
    assert_select s, 0
    setup{@show_labels=true}
    assert_select s, 1
  end

  test "should be editable" do
    s=@dft.child 'input'
    assert_select s, 0
    setup{@edit_fields=true}
    assert_select s, 1
  end

  test "happy path should render..." do
# Pretty html source:
    check_pretty_html_source nil, 'field'
# The right partial, once:
    assert_partial
# One field div:
    assert_select @df, 1
# Div for field:
    assert_select @dt, 1
    assert_select @dft, 1
# A model attribute:
    assert_select @dft, @title
  end

#-------------
  private

  def setup(&block)
# Naming this method, 'render' and using 'super', failed somehow.
    controller_yield &block
    record=Picture.new
    record[field=:title]=(@title='some_title')
    render_partial 'pictures/field', :record => record,
        :field => field
    @df, @dt, @dl = %w[field title label].map{|e| CssString.new('div').
        css_class e}
    @dft=@df.child @dt
  end

end
