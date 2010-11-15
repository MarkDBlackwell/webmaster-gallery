require 'test_helper'

class ApplicationLayoutTest < ActionView::TestCase
  helper PicturesHelper

  test "should include this file" do
#    flunk
  end

#-------------
# Rendering tests:

  test "should render manage session buttons once" do
    assert_template :partial => 'application/_buttons', :count => 1
  end

  test "should render messages once" do
    assert_template :partial => 'application/_messages', :count => 1
  end

  test "should render styles once" do
    assert_template :partial => 'application/_styles', :count => 1
  end

#-------------
# Html tests:

  test "should be one html tag" do
    assert_select 'html', 1
  end

  test "html tag should include one head tag" do
    assert_select 'html head', 1
  end

  test "head tag should include one style tag" do
    assert_select 'head style', 1
    assert_select 'head style.styles', 1
  end

  test "html tag should include one body tag" do
    assert_select 'html body', 1
  end

#-------------
# Body tests:

  test "body should include one messages div" do
    assert_select 'body div.messages', 1
  end

  test "body should include one manage-session div whether or not manage- "\
       "session buttons are suppressed" do
    assert_select 'body div.manage-session', 1
    setup :@suppress_buttons => true
    assert_select 'body div.manage-session', 2 # Cumulative.
  end

  test "body should include one action content div" do
    assert_select 'body div.action-content', 1
  end

#-------------
  private

  def render_layout(filename, instance_variables={})
# Sample arguments to render:
#   render :file => "#{Rails.root}/app/views/layouts/application", :locals =>
#       {:@suppress_buttons => true}
# Would be called this way:
#   render_layout :@suppress_buttons => true
# Another way to do it:
#    @controller.instance_variable_set(:@suppress_buttons,true)
#-------------
    render :file => filename, :locals => instance_variables
  end

  def setup(*args)
    render_layout "#{Rails.root}/app/views/layouts/application", *args
  end

end
