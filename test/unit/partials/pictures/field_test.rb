require 'test_helper'
should_include_this_file

class PicturesFieldPartialTest < ActionView::TestCase
  include PartialTestShared

  test "should render" do
    assert_template :partial => 'pictures/_field'
  end

  test "should include one field div" do
    assert_select 'div.field', 1
  end

  test "should render div for field" do
    assert_select 'div.title', 1
    assert_select 'div.field > div.title', 1
  end

  test "should render a model attribute" do
    assert_select 'div.field > div.title', 'some_title'
  end

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

#-------------
  private

  def setup(&block)
# Naming this method, 'render' and using 'super', failed somehow.
    controller_yield &block
    record=Picture.new
    field_name=:title
    field_value='some_title'
    record[field_name]=field_value
    render :partial => 'pictures/field', :locals => {:record => record,
        :name => field_name}
  end

end
