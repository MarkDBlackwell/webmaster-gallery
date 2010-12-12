require 'test_helper'

class ButtonsApplicationPartialTest < SharedPartialTest

  test "should obey the suppress buttons flag" do
    assert_select 'div.session-buttons div', 5
    setup{@suppress_buttons=true}
    assert_select 'div.session-buttons div', 0
  end

  test "happy path..." do
# Should render pretty html source:
    check_pretty_html_source 'Session buttons', %w[
        admin-pictures-index  destroy  edit  session-buttons  show
        user-pictures-index  ]
# Should render:
    assert_partial
# Should include one session-buttons div:
    assert_select 'div.session-buttons', 1
# Should render these buttons:
    %w[admin-pictures-index  edit  show  user-pictures-index].each do |e|
      css="div.session-buttons > div.#{e} > form.button_to"
      assert_select css, 1, e
    end
  end

#-------------
  private

  def setup(&block)
    controller_yield &block
    render_partial 'application/buttons'
  end

end
