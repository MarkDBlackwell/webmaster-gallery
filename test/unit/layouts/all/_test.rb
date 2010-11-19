require 'test_helper'

class AllLayoutTest < SharedLayoutTest
  helper PicturesHelper

  test "should render session buttons once" do
    assert_template :partial => 'application/_buttons', :count => 1
  end

  test "should render messages once" do
    assert_template :partial => 'application/_messages', :count => 1
  end

  test "should render scripts once" do
    assert_template :partial => 'application/_scripts', :count => 1
  end

  test "should render styles once" do
    assert_template :partial => 'application/_styles', :count => 1
  end

#-------------
# Html tests:

  test "should have the right document type" do
    assert_doctype
  end

  test "should be one html tag" do
    assert_select 'html', 1
  end

  test "html tag should include one head, first" do
    assert_select 'head', 1
    assert_select 'html head', 1
    assert_select 'html > head:first-child', 1
  end

  test "html tag should include one body, last" do
    assert_select 'body', 1
    assert_select 'html body', 1
    assert_select 'html > body:last-child', 1
  end

#-------------
# Head tests:

  test "head should include one title, first" do
    assert_select 'title', 1
    assert_select 'head title', 1
    assert_select 'head > title:first-child', 1
  end

  test "head should include one scripts div, after the title" do
    assert_select 'div.scripts', 1
    assert_select 'head title + div.scripts', 1
  end

  test "head should include one style tag, last" do
    assert_select 'style', 1
    assert_select 'head > style:last-child', 1
  end

#-------------
# Body tests:

  test "body should include one messages div" do
    assert_select 'div.messages', 1
    assert_select 'body div.messages', 1
  end

  test "body should include one session-buttons div whether or not manage- "\
       "session buttons are suppressed" do
    assert_select 'div.session-buttons', 1
    assert_select 'body div.session-buttons', 1
    setup :@suppress_buttons => true
    assert_select 'div.session-buttons', 1
    assert_select 'body div.session-buttons', 1
  end

  test "body should include one action content div" do
    assert_select 'div.action-content', 1
    assert_select 'body div.action-content', 1
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

  def assert_template(*args)
    render_all_layouts {super}
  end

  def render_all_layouts
    @filenames.each do |f|
      setup_with_controller if @need_reload
      @need_reload=true
      render_layout f, *@instance_variables
      yield
    end
  end

  def setup(*args)
    @instance_variables=args
    @need_reload=false unless args
    unless @filenames
      d="#{Rails.root}/app/views/layouts"
      @filenames=((Dir.entries d) - %w[.. .]).
          collect {|e| "#{d}/#{e.chomp '.html.erb'}" }
    end
  end

end
