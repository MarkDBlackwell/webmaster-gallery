require 'test_helper'

class AllLayoutTest < SharedLayoutTest

  test "layouts..." do
    layouts do
# Partials...:
# Should render a list of all tags once:
      assert_partial 'pictures/_all_tags', 1
# Should render messages once:
      assert_partial 'application/_messages', 1
# Should render scripts once:
      assert_partial 'application/_scripts', 1
# Should render the session buttons once:
      assert_partial 'application/_buttons', 1
# Should render styles once:
      assert_partial 'application/_styles', 1
#-------------
# Should render pretty html source:
      check_pretty_html_source( %w[
  Action\ content  All\ tags  Messages  Scripts  Session\ buttons  Styles
      ], %w[
  action-content  admin-pictures-index  all-tags  destroy  edit  messages
  scripts  session-buttons  show  user-pictures-index 
      ], %w[
  /body></html  !DOCTYPE\ html  /head></body  html><head  script
  script\ src="/javascripts/  style  /style  title
      ], %w[  div. ])
#-------------
# Html...
# Should have the right document type:
      assert_doctype
# Should include one html tag:
      assert_select 'html', 1
# Html tag should include one head, first:
      assert_select 'head', 1
      assert_select 'html head', 1
      assert_select 'html > head:first-child', 1
# Html tag should include one body, last:
      assert_select 'body', 1
      assert_select 'html body', 1
      assert_select 'html > body:last-child', 1
#-------------
# Html head section...
# Should include one title, first:
      assert_select 'title', 1
      assert_select 'head title', 1
      assert_select 'head > title:first-child', 1
# Should include one scripts div, after the title:
      assert_select (s='div.scripts'), 1
      assert_select 'head title + '+s, 1
# Should include one style tag, last:
      assert_select 'style', 1
      assert_select 'head > style:last-child', 1
#-------------
# Html body section...
# Should include one messages div:
      assert_select (s='div.messages'), 1
      assert_select 'body '+s, 1
# Should include one session-buttons div whether or not manage-session buttons
# are suppressed:
      assert_select (s='div.session-buttons'), 1
      assert_select 'body '+s, 1
    end
    setup :@suppress_buttons => true
    layouts do
      assert_select (s='div.session-buttons'), 1
      assert_select 'body '+s, 1
# Should include one all-tags div:
      assert_select (s='div.all-tags'), 1
      assert_select 'body '+s, 1
# Should include one action content div:
      assert_select (s='div.action-content'), 1
      assert_select 'body '+s, 1
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
      @filenames=[]
      App.root.join('app/views/layouts').find do |path|
        b=path.basename.to_s
        Find.prune if path.directory? && ?.==b[0]
        @filenames << path.dirname.join(b.chomp '.html.erb') if path.file?
      end
    end
  end

end
