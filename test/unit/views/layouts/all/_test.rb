require 'test_helper'

class AllLayoutTest < SharedLayoutTest

  test "should render pretty html source" do
    check_pretty_html_source( %w[
Action\ content  All\ tags  Messages  Scripts  Session\ buttons  Styles
        ], %w[
action-content admin-pictures-index all-tags destroy edit messages scripts 
session-buttons show user-pictures-index 
        ], %w[
/body></html  !DOCTYPE\ html  /head></body  html><head  script
script\ src="/javascripts/  style  /style  title
        ], %w[  div. ])
  end

  test "partials..." do
    layouts do
# Should render a list of all tags once:
      assert_template :partial => 'pictures/_all_tags', :count => 1
# Should render messages once:
      assert_template :partial => 'application/_messages', :count => 1
# Should render scripts once:
      assert_template :partial => 'application/_scripts', :count => 1
# Should render session buttons once:
      assert_template :partial => 'application/_buttons', :count => 1
# Should render styles once:
      assert_template :partial => 'application/_styles', :count => 1
    end
  end

  test "html tests" do
    layouts do
# Should have the right document type:
      assert_doctype
# Should be one html tag:
      assert_select 'html', 1
# Html tag should include one head, first:
      assert_select 'head', 1
      assert_select 'html head', 1
      assert_select 'html > head:first-child', 1
# Html tag should include one body, last:
      assert_select 'body', 1
      assert_select 'html body', 1
      assert_select 'html > body:last-child', 1
    end
  end

  test "head..." do
    layouts do
# Should include one title, first:
      assert_select 'title', 1
      assert_select 'head title', 1
      assert_select 'head > title:first-child', 1
# Should include one scripts div, after the title:
      assert_select 'div.scripts', 1
      assert_select 'head title + div.scripts', 1
# Should include one style tag, last:
      assert_select 'style', 1
      assert_select 'head > style:last-child', 1
    end
  end

  test "body..." do
    layouts do
# Should include one messages div:
      assert_select 'div.messages', 1
      assert_select 'body div.messages', 1
# Should include one session-buttons div whether or not manage-session buttons
# are suppressed:
      assert_select 'div.session-buttons', 1
      assert_select 'body div.session-buttons', 1
    end
    setup :@suppress_buttons => true
    layouts do
      assert_select 'div.session-buttons', 1
      assert_select 'body div.session-buttons', 1
# Should include one all-tags div:
      assert_select 'div.all-tags', 1
      assert_select 'body div.all-tags', 1
# Should include one action content div:
      assert_select 'div.action-content', 1
      assert_select 'body div.action-content', 1
    end
  end

#-------------
  private

  def assert_doctype
    s="<!DOCTYPE html>\n"
    assert (rendered.start_with? s), s
  end

  def layouts
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
      @filenames=((Dir.entries d) - %w[. ..]).
          collect {|e| "#{d}/#{e.chomp '.html.erb'}" }
    end
  end

end
