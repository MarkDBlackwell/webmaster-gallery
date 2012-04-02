require 'test_helper'

class ReviewGroupSessionsPartialTest < SharedPartialTest
# %%vi%%part%%ses%%rg

  test "happy path should render the right..." do
    happy_path
# Partial, once:
    assert_partial
# Div class:
    assert_select @dg, 1
# Which should contain the right...:
# Message, once:
    assert_select @gm, 1
    assert_single @dm, @group.message
# List, once:
    assert_select @gl, 1
# Which should contain the right...:
# Number of pictures:
    assert_select @ga, 2
    assert_select @da, 2
    assert_select @a, 2
# Picture filenames, each once:
# And only the pictures:
    assert_select (@dl.descend '*'), 4
    assert_select (@dl.child 'a'), 2
    assert_select (@dl.child(@d).css_class 'picture-errors'), 2
    assert_single @dl, (@group.list.map(&:filename).map{|e| e+'.'}.join "\n")
  end

  test "if list is not of a model" do
    render_partial
# Should render the list itself:
    assert_single @gl, (@group.list.join ' ')
  end

  test "if list is empty" do
    @group.list=[]
    render_partial
# Should render a special list value:
    assert_single @gl, @special
  end

  test "if message is empty" do
    @group.message=''
    render_partial
# Should render the empty message:
    assert_single @gm, ''
  end

  test "if both list and message are empty, should render..." do
    @group.list, @group.message = [], ''
    render_partial
# A special list value:
    assert_single @gl, @special
# The empty message:
    assert_single @gm, ''
  end

#-------------

  def setup
    c=:sessions
    @controller.default_url_options={:controller=>c}
    @group=Struct.new(:list,:message).new  %w[abc def], 'something'
    @special='(none)'
    @a,@d = %w[a div].map{|e| CssString.new e}
    @dg,@dl,@dm = %w[group  list  message].map{|e| @d.css_class 'review-'+e}
    @gl,@gm=[@dl,@dm].map{|e| @dg.child e}
    @da,@ga=[@dl,@gl].map{|e| e.child @a}
  end

  private

  def happy_path
    @group.list=Picture.all
    render_partial
  end

  def render_partial
    super 'sessions/review_group', :review_group => @group
  end

end
