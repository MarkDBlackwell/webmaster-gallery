require 'test_helper'

class AllLayoutTest < SharedLayoutTest

  test "layouts..." do
    layouts do
# Partials should render...:
# A list of all tags, once:
      assert_partial 'pictures/_all_tags', 1
# Messages, once:
      assert_partial (s='application/_' ) + 'messages', 1
# Scripts, once:
      assert_partial s+'scripts', 1
# The session buttons, once:
      assert_partial s+'buttons', 1
# Styles, once:
      assert_partial s+'styles', 1
#-------------
# Pretty html source:
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
# Html should...
# Have the right document type:
      assert_doctype
# Include one html tag:
      assert_select @ht, 1
# Html tag should include...
# One head, first:
      assert_select @h, 1
      assert_select @ht.descend(@h), 1
      assert_select @ht.first(@h), 1
# One body, last:
      assert_select @b, 1
      assert_select @ht.descend(@b), 1
      assert_select @ht.last(@b), 1
#-------------
# Html head section should include...
# One title, first:
      assert_select @t, 1
      assert_select @h.descend(@t), 1
      assert_select @h.first(@t), 1
# One scripts div, after the title:
      assert_select @ds, 1
      assert_select @h.descend(@t.adjacent @ds), 1
# One style tag, last:
      assert_select @s, 1
      assert_select @h.last(@s), 1
#-------------
# Html body section should include...
# One messages div:
      assert_select @dm, 1
      assert_select @b.descend(@dm), 1
# One session-buttons div, whether or not manage-session buttons are suppressed:
      assert_select @dsb, 1
      assert_select @b.descend(@dsb), 1
    end
    setup :@suppress_buttons => true
    layouts do
      assert_select @dsb, 1
      assert_select @b.descend(@dsb), 1
# One all-tags div:
      assert_select @dat, 1
      assert_select @b.descend(@dat), 1
# One action content div:
      assert_select @dac, 1
      assert_select @b.descend(@dac), 1
    end
  end

#-------------
  private

  def assert_doctype
    s="<!DOCTYPE html>\n"
    assert rendered.start_with?(s), s
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
    begin
      @filenames=[]
      App.root.join('app/views/layouts').find do |path|
        b=path.basename.to_s
        Find.prune if path.directory? && ?.==b[0]
        @filenames << path.dirname.join(b.chomp '.html.erb') if path.file?
      end
    end unless @filenames
    @b, @h, @ht, @s, @t = %w[body head html style title].map{|e| CssString.
        new e}
    @ds, @dm, @dsb, @dat, @dac =
        %w[scripts  messages  session-buttons  all-tags  action-content].
        map{|e| (CssString.new 'div.') + e}
  end

end
