require 'test_helper'
should_include_this_file

class ApplicationButtonsPartialTest < ActionView::TestCase

  test "should render" do
    assert_template :partial => 'application/_buttons'
  end

  test "should include manage-session div" do
    assert_select 'div.manage-session', 1
  end

  test "should obey the suppress buttons flag" do
    assert_select 'div.manage-session div', 5
    setup {@suppress_buttons=true}
    assert_select 'div.manage-session div', 0
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
    css = "div.manage-session > div.#{s} > form.button_to"
    assert_select css, 1
  end

  def setup(&block)
    setup_if_block_given &block
    render :partial => 'application/buttons'
  end

  def setup_if_block_given
    if block_given?
      setup_with_controller
      yield
    end
  end

end
