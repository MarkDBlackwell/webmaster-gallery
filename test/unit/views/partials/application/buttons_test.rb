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
# A single session-buttons div:
    assert_select @ds, 1
# Various buttons:
    %w[admin-pictures-index  edit  show  user-pictures-index].each do |e|
      assert_select @ds.child(@d.css_class(e), @f.css_class('button_to')), 1, e
    end
# And...
# User pictures form should...:
    assert_select @ds.child(@d.css_class('user-pictures-index'), @f.css_class(
        'button_to')), 1 do
# Contain a button:
      assert_select (@f.child @d, @i), 1 do
        assert_select (@i.attribute 'type', '?'), 'submit'
        assert_select (@i.attribute 'value', '?'), 'user pictures'
      end
# Link to the right URL:
      assert_select (@f.attribute 'action', '?'),
          (url_for :controller => :pictures, :action => :index)
# Open in a new window:
      assert_select (@f.attribute 'target', '?'), '_blank'
# Use http method, 'get':
      assert_select (@f.attribute 'method', '?'), 'get'
    end
# TODO: add tests for the other buttons.
  end

#-------------
  private

  def setup(&block)
    controller_yield &block
    render_partial 'application/buttons'
    @d, @f, @i = %w[div form input].map{|e| CssString.new e}
    @ds=@d.css_class 'session-buttons'
    @dd=@ds.descend @d
  end

end
