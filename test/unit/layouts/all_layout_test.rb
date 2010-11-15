require 'test_helper'

class AllLayoutTest < ActionView::TestCase
  include PrivateAllLayoutTest
  helper PicturesHelper

  test "should include this file" do
#    flunk
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
  private

  def setup(*args)
    setup_with_controller unless args.empty?
    render_layout "#{Rails.root}/app/views/layouts/application", *args
  end

end
