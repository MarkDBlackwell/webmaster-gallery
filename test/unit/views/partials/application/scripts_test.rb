require 'test_helper'

class ScriptsApplicationPartialTest < SharedViewTest

  test "should render pretty html source" do
    check_pretty_html_source 'Scripts', 'scripts', 'script'
  end

  test "scripts div should include certain script tags in order" do
    %w[prototype effects dragdrop controls rails application].
        each_with_index do |e,i|
      assert_select "div.scripts > #{'script + '*i} script[src=?]",
          Regexp.new(%Q@/javascripts/#{e}\\.js\\?\\d*\\z@)
    end
  end

  test "scripts partial..." do
# Should render:
    assert_template :partial => 'application/_scripts', :count => 1
# Should include one scripts div:
    assert_select 'div.scripts', 1
# Scripts div should include six script tags:
    assert_select 'div.scripts script', 6
    assert_select 'div.scripts script[type=text/javascript]', 6
  end

#-------------
  private

  def setup
    render :partial => 'application/scripts'
  end

end
