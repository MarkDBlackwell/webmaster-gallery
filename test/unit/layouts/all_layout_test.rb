require 'test_helper'

class AllLayoutTest < ActionView::TestCase
  include PrivateAllLayoutTest
  helper PicturesHelper

  test "should include this file" do
#    flunk
  end

  test "should have the right document type" do
    assert_equal '<!DOCTYPE html>', (rendered.slice 0...rendered.index("\n"))
  end

#-------------
# Html tests:

  test "should be one html tag" do
    assert_select 'html', 1
  end

  test "html tag should include one head tag" do
    assert_select 'html head', 1
  end

  test "head tag should include one title tag" do
    assert_select 'head title', 1
    assert_select 'head > title:first-child', 1
  end

  test "head tag should include six script tags" do
    assert_select 'head script', 6
  end

  test "head tag should include certain script tags" do
    %w[prototype effects dragdrop controls rails application
        ].each_with_index do |e,i|
      assert_select "head title + #{'* + '*i} script[src=?]",
          Regexp.new(%Q@/javascripts/#{e}\\.js\\?\\d*\\z@)
    end
  end

  test "head tag should include one style tag" do
    assert_select 'head style', 1
    assert_select 'head style.styles', 1
    assert_select 'head > style:last-child', 1
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
