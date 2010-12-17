require 'test_helper'

class MessagesApplicationPartialTest < SharedPartialTest

  test "happy path should render..." do
# Pretty html source:
    check_pretty_html_source 'Messages', %w[messages  notice  notice\ error]
# The right partial, once:
    assert_partial
# And...
# Include one messages div:
    assert_select CssString.new('div').css_class('messages'), 1
  end

#-------------
  private

  def setup
    [:error,:notice].each{|e| flash.now[e]="some #{e}" }
    render_partial 'application/messages'
  end

end
