require 'test_helper'
should_include_this_file

class ApplicationLayoutTest < ActionView::TestCase
  include PrivateLayoutTest
  helper PicturesHelper

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
# Body tests:

  test "body should include one messages div" do
    assert_select 'body div.messages', 1
  end

  test "body should include one manage-session div whether or not manage- "\
       "session buttons are suppressed" do
    assert_select 'body div.manage-session', 1
    setup :@suppress_buttons => true
    assert_select 'body div.manage-session', 1
  end

  test "body should include one action content div" do
    assert_select 'body div.action-content', 1
  end

#-------------
  private

  def setup(*args)
    setup_with_controller unless args.empty?
    render_layout "#{Rails.root}/app/views/layouts/application", *args
  end

end
