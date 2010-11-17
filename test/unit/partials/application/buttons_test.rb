require 'test_helper'
should_include_this_file

class ApplicationButtonsPartialTest < ActionView::TestCase
  include PartialTestShared

  test "should render" do
    assert_template :partial => 'application/_buttons'
  end

  test "should include one session-buttons div" do
    assert_select 'div.session-buttons', 1
  end

  test "should obey the suppress buttons flag" do
    assert_select 'div.session-buttons div', 5
    setup {@suppress_buttons=true}
    assert_select 'div.session-buttons div', 0
  end

  test "should render an edit button" do
    session_buttons_include? 'edit'
  end

  test "should render a show button" do
    session_buttons_include? 'show'
  end

  test "should render an AdminPictures index button" do
    session_buttons_include? 'admin-pictures-index'
  end

  test "should render a Pictures index button" do
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
    render :partial => 'application/buttons'
  end

end
