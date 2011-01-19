require 'test_helper'

class MessagesApplicationPartialTest < SharedPartialTest
# %%vi%%part%%app%%mes

  test "happy path should render..." do
# Pretty html source:
    check_pretty_html_source 'Messages', %w[messages  notice  notice\ error]
# The right partial, once:
    assert_partial
# And...
# Include one messages div with the right contents:
    assert_single CssString.new('div').css_class('messages'), @text
  end

#-------------
  private

  def setup
    @text=[:notice,:error].map{|e| s="some #{e}"; flash.now[e]=s}.join "\n"
    render_partial 'application/messages'
  end

end
