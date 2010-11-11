require 'test_helper'

class PicturesTextFieldPartialTest < ActionView::TestCase

#-------------
# Find method tests:

  test "should include this file" do
#    flunk
  end

  test "should render" do
    render *@args
    assert_template *@args
  end

  test "should render div for field" do
    render *@args
    assert_select 'div.title'
  end

  test "should render something" do
    render *@args
    assert_select 'div.title', @field_value
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
    @picture=Picture.new
    @field_value='some_title'
    @field=:title
    @picture[@field]=@field_value
    @args=[:partial => 'pictures/text_field', :locals => {:record => @picture,
        :name => @field}]
  end

end
