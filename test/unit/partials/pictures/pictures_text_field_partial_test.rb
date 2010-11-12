require 'test_helper'

class PicturesTextFieldPartialTest < ActionView::TestCase

#-------------
# Find method tests:

  test "should include this file" do
#    flunk
  end

  test "should render" do
    render *@args
    assert_template :partial => 'pictures/_text_field'
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
    r=Picture.new
    n=:title
    @value='some_title'
    r[n]=@value
    @args=[:partial => 'pictures/text_field', :locals => {:record => r,
        :name => n}]
  end

end
