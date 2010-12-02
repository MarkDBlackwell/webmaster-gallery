require 'test_helper'

class ButtonsApplicationPartialTest < SharedPartialTest

  test "should obey the suppress buttons flag" do
    assert_select 'div.session-buttons div', 5
    setup {@suppress_buttons=true}
    assert_select 'div.session-buttons div', 0
  end

  test "happy path..." do
# Should render pretty html source:
    check_pretty_html_source 'Session buttons', %w[
        admin-pictures-index  destroy  edit  session-buttons  show
        user-pictures-index  ]
# Should render:
    assert_partial @partial, 1
# Should include one session-buttons div:
    assert_select 'div.session-buttons', 1
# Should render an edit button:
    session_buttons_include? 'edit'
# Should render a show button:
    session_buttons_include? 'show'
# Should render an AdminPictures index button:
    session_buttons_include? 'admin-pictures-index'
# Should render a Pictures index button:
    session_buttons_include? 'user-pictures-index'
  end

#-------------
  private

  def session_buttons_include?(s)
    css = "div.session-buttons > div.#{s} > form.button_to"
    assert_select css, 1
  end

  def setup(&block)
    controller_yield &block
    render_partial @partial='application/buttons'
  end

end
