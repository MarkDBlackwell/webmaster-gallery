require 'test_helper'

class ReviewGroupSessionsPartialTest < SharedPartialTest

  test "happy path should render the right..." do
    happy_path
# Partial, once:
    assert_partial
    assert_select @dg, 1 do
# Message, once:
      assert_select @dm, 1
      assert_select @dm, :text => @group.message
      assert_select @gm, 1
# Pictures, once:
      assert_select @dl, 1
      assert_select @gl, 1
# Number of pictures:
      assert_select @la, 2
# Picture filenames, once:
      assert_select @la.first, :text => @group.list.first.filename
      assert_select @la.last,  :text => @group.list.last .filename
    end
  end

  test "if list is not of a model" do
    render_partial
# Should render the list itself:
    assert_select @gl, :text => (@group.list.join ' ')
  end

  test "if list is empty" do
    @group.list=[]
    render_partial
# Should render a special list value:
    assert_select @gl, :text => '(none)'
  end

  test "if message is empty" do
    @group.message=''
    render_partial
# Should remder the empty message:
    assert_select @gm, :text => ''
  end

  test "if both list and message are empty, should render..." do
    @group.list, @group.message = [], ''
    render_partial
# A special list value:
    assert_select @gl, :text => '(none)'
# The empty message:
    assert_select @gm, :text => ''
  end

#-------------
  private

  def happy_path
    @group.list=Picture.find :all
    render_partial
  end

  def render_partial
    super 'sessions/review_group', :review_group => @group
  end

  def setup
    @use_controller=:admin_pictures
    @group=Struct.new(:list,:message).new  %w[abc def], 'something'
    @d=CssString.new 'div'
    @dg, @dl, @dm = %w[group  list  message].map{|e| @d.css_class 'review-'+e}
    @gl=@dg.child @dl
    @gm=@dg.child @dm
    @la=@dl.child 'a'
  end

end
