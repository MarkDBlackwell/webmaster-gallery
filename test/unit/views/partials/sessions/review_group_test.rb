require 'test_helper'

class ReviewGroupSessionsPartialTest < SharedPartialTest

  test "happy path should render..." do
    happy_path
# The right partial, once:
    assert_partial
    assert_select @dg, 1 do
# The right message, once:
      assert_select @dm, 1
      assert_select @dm, :text => @group.message
      assert_select @dgm, 1
# The right picture filenames, once:
      assert_select @dl, 1
      assert_select @dl, :text => (@group.list.map(&:filename).join ' ')
      assert_select @dgl, 1
    end
  end

  test "if list is not of a model" do
    render_partial
# Should render the list itself:
    assert_select @dgl, :text => (@group.list.join ' ')
  end

  test "if list is empty" do
    @group.list=[]
    render_partial
# Should render a special list value:
    assert_select @dgl, :text => '(none)'
  end

  test "if message is empty" do
    @group.message=''
    render_partial
# Should remder the empty message:
    assert_select @dgm, :text => ''
  end

  test "if both list and message are empty" do
    @group.list,@group.message=[],''
    render_partial
# Should render a special list value:
    assert_select @dgl, :text => '(none)'
# Should remder the empty message:
    assert_select @dgm, :text => ''
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
    @d='div.review-'
    @dg=@d+'group'
    @dl=@d+'list'
    @dm=@d+'message'
    @dgl=@dg+'>'+@dl
    @dgm=@dg+'>'+@dm
    @group=Struct.new(:list,:message).new  %w[abc def], 'something'
  end

end
