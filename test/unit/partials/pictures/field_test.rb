require 'test_helper'
should_include_this_file

class PicturesTextFieldPartialTest < ActionView::TestCase

  test "should render" do
    render *@args
    assert_template :partial => 'pictures/_field'
  end

  test "should include one text-field div" do
    render *@args
    assert_select 'div.text-field', 1
  end

  test "should render div for field" do
    render *@args
    assert_select 'div.title'
  end

  test "should render a model attribute" do
    render *@args
    assert_select 'div.title', @value
  end

  test "should render labels" do
    @show_labels=true
    render *@args
    assert_select 'div.title'
  end

  test "should be editable" do
    @edit_fields=true
    render *@args
    assert_select 'div.title > input'
  end

#-------------
  private

  def setup
    record=Picture.new
    name=:title
    @value='some_title'
    record[name]=@value
    @args=[:partial => 'pictures/field', :locals => {:record => record,
        :name => name}]
  end

end
