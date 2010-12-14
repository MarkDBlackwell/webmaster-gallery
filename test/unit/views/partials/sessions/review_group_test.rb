require 'test_helper'

class ReviewGroupSessionsPartialTest < SharedPartialTest

  test "happy path..." do
    happy_path
# Should render the right partial:
    assert_partial
    assert_select (sg=@d+'group'), 1 do
# Should render the right message:
      assert_select (sm=@d+'message'), 1
      assert_select sm, :text => @group.message
      assert_select "#{sg} > #{sm}", 1
# Should render the right picture filenames:
      assert_select (sl=@d+'list'), 1
      assert_select sl, :text => (@group.list.map(&:filename).join ' ')
      assert_select "#{sg} > #{sl}", 1
    end
  end

  test "if list is not of a model" do
    render_partial
# Should render the list itself:
    assert_select @d+"group > #{@d}list", :text => (@group.list.join ' ')
  end

  test "if list is empty" do
    @group.list=[]
    render_partial
# Should render a special list value:
    assert_select @d+"group > #{@d}list", :text => '(none)'
  end

  test "if message is empty" do
    @group.message=''
    render_partial
# Should remder the empty message:
    assert_select @d+"group > #{@d}message", :text => ''
  end

  test "if both list and message are empty" do
    @group.list,@group.message=[],''
    render_partial
# Should render a special list value:
    s=@d+"group > #{@d}"
    assert_select s+'list', :text => '(none)'
# Should remder the empty message:
    assert_select s+'message', :text => ''
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
    @group=Struct.new(:list,:message).new  %w[abc def], 'something'
    @d='div.review-'
  end

end
