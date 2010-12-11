require 'test_helper'

class ScriptsApplicationPartialTest < SharedPartialTest

  test "scripts div should include certain script tags in order" do
    %w[prototype effects dragdrop controls rails application].
        each_with_index do |e,i|
      assert_select "div.scripts > #{'script + '*i} script[src=?]",
# TODO: use Regexp twice:
          (Regexp.new %Q@/javascripts/#{e}\\.js\\?\\d*\\z@ )
    end
  end

  test "happy path..." do
# Should render pretty html source:
    check_pretty_html_source 'Scripts', 'scripts', 'script'
# Should render:
    assert_partial
# Should include one scripts div:
    assert_select (s='div.scripts'), 1
# Scripts div should include six script tags:
    assert_select (s=s+' script'), 6
    assert_select s+'[type=text/javascript]', 6
  end

#-------------
  private

  def setup
    render_partial 'application/scripts'
  end

end
