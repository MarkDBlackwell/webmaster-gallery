require 'test_helper'

class LayoutTest < ActionView::TestCase
  include PrivateLayoutTest
  helper PicturesHelper

  test "should include this file" do
#    flunk
  end

  test "should have the right document type" do
    assert_doctype
  end

#-------------
# Html tests:

  test "should be one html tag" do
    assert_select 'html', 1
  end

  test "html tag should include one head tag" do
    assert_select 'html head', 1
  end

  test "head tag should first include one title tag" do
    assert_select 'head title', 1
    assert_select 'head > title:first-child', 1
  end

  test "head tag should include six script tags" do
    assert_select 'head script', 6
    assert_select 'head script[type=text/javascript]', 6
  end

  test "head tag should include certain script tags in order" do
    %w[prototype effects dragdrop controls rails application].
        each_with_index do |e,i|
      assert_select "head title + #{'* + '*i} script[src=?]",
          Regexp.new(%Q@/javascripts/#{e}\\.js\\?\\d*\\z@)
    end
  end

  test "head tag should include one style tag" do
    assert_select 'head style', 1
    assert_select 'head > style:last-child', 1
    assert_select 'head style.styles[type=text/css]', 1
  end

  test "html tag should include one body tag" do
    assert_select 'html body', 1
  end

#-------------
  private

  def assert_doctype
    s="<!DOCTYPE html>\n"
    render_all_layouts {assert (rendered.start_with? s), s}
  end

  def assert_select(*args)
    render_all_layouts {super}
  end

  def render_all_layouts
    @filenames.each do |f|
      setup_with_controller if @need_reload
      @need_reload=true
      render_layout f
      yield
    end
  end

  def setup
    @need_reload=false
    unless @filenames
      d="#{Rails.root}/app/views/layouts"
      @filenames=((Dir.entries d) - %w[.. .]).
          collect {|e| "#{d}/#{e.chomp '.html.erb'}" }
    end
  end

end
