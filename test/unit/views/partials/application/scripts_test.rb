require 'test_helper'

class ScriptsApplicationPartialTest < ActionView::TestCase

  test "should render" do
    assert_template :partial => 'application/_scripts'
  end

  test "should include one scripts div" do
    assert_select 'div.scripts', 1
  end

  test "scripts div should include six script tags" do
    assert_select 'div.scripts script', 6
    assert_select 'div.scripts script[type=text/javascript]', 6
  end

  test "scripts div should include certain script tags in order" do
    %w[prototype effects dragdrop controls rails application].
        each_with_index do |e,i|
      assert_select "div.scripts > #{'script + '*i} script[src=?]",
          Regexp.new(%Q@/javascripts/#{e}\\.js\\?\\d*\\z@)
    end
  end

#-------------
  private

  def setup
    render :partial => 'application/scripts'
  end

end
