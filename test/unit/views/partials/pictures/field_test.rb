require 'test_helper'

class FieldPicturesPartialTest < SharedPartialTest

  test "should render labels" do
    assert_select 'div.field > div.title > div.label', 0
    setup {@show_labels=true}
    assert_select 'div.field > div.title > div.label', 1
  end

  test "should be editable" do
    assert_select 'div.field > div.title > input', 0
    setup {@edit_fields=true}
    assert_select 'div.field > div.title > input', 1
  end

  test "happy path..." do
# Should render pretty html source:
    check_pretty_html_source nil, 'field'
# Should render:
    assert_partial @partial, 1
# Should include one field div:
    assert_select 'div.field', 1
# Should render div for field:
    assert_select 'div.title', 1
    assert_select 'div.field > div.title', 1
# Should render a model attribute:
    assert_select 'div.field > div.title', 'some_title'
  end

#-------------
  private

  def setup(&block)
# Naming this method, 'render' and using 'super', failed somehow.
    controller_yield &block
    record=Picture.new
    record[field=:title]='some_title'
    render_partial @partial='pictures/field', :record => record,
        :field => field
  end

end
