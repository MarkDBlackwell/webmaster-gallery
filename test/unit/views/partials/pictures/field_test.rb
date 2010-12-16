require 'test_helper'

class FieldPicturesPartialTest < SharedPartialTest

  test "should render labels" do
    s='div.field > div.title > div.label'
    assert_select s, 0
    setup{@show_labels=true}
    assert_select s, 1
  end

  test "should be editable" do
    s='div.field > div.title > input'
    assert_select s, 0
    setup{@edit_fields=true}
    assert_select s, 1
  end

  test "happy path..." do
# Should render pretty html source:
    check_pretty_html_source nil, 'field'
# Should render the right partial, once:
    assert_partial
# Should include one field div:
    assert_select 'div.field', 1
# Should render div for field:
    assert_select 'div.title', 1
    assert_select (s='div.field > div.title'), 1
# Should render a model attribute:
    assert_select s, 'some_title'
  end

#-------------
  private

  def setup(&block)
# Naming this method, 'render' and using 'super', failed somehow.
    controller_yield &block
    record=Picture.new
    record[field=:title]='some_title'
    render_partial 'pictures/field', :record => record,
        :field => field
  end

end
