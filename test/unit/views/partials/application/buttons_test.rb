require 'test_helper'

class ButtonsApplicationPartialTest < SharedPartialTest

  test "should obey the suppress buttons flag" do
    assert_select @dd, 5
    setup{@suppress_buttons=true}
    assert_select @dd, 0
  end

  test "happy path should render..." do
# Pretty html source:
    check_pretty_html_source 'Session buttons', %w[
        admin-pictures-index  destroy  edit  session-buttons  show
        user-pictures-index ]
# The right partial, once:
    assert_partial
# These buttons:
    %w[admin-pictures-index  edit  show  user-pictures-index].each do |e|
      assert_select @ds.child(@d.css_class(e), @f.css_class('button_to')), 1, e
    end
# And...
# Include one session-buttons div:
    assert_select @ds, 1
  end

#-------------
  private

  def setup(&block)
    controller_yield &block
    render_partial 'application/buttons'
    @d, @f = %w[div form].map{|e| CssString.new e}
    @ds=@d.css_class 'session-buttons'
    @dd=@ds.descend @d
  end

end
