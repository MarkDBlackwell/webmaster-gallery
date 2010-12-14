require 'test_helper'

class ReviewGroupSessionsPartialTest < SharedPartialTest

  test "happy path..." do
    happy_path
# Should render the right partial:
    assert_partial
    assert_select (s1='div.review-group'), 1 do
# Should render the right message:
      assert_select (s2='div.review-message'), 1
      assert_select s2, :text => @group.message
      assert_select "#{s1} > #{s2}", 1
# Should render the right picture filenames:
      assert_select (s3='div.review-list'), 1
      assert_select s3, :text => (@group.list.map(&:filename).join ' ')
      assert_select "#{s1} > #{s3}", 1
    end
  end

  test "if list is not of a model" do
    render_partial %w[def abc]
# Should render the list itself:
    assert_select 'div.review-group > div.review-list', :text =>
        (@group.list.join ' ')
  end

  test "if list is empty" do
    render_partial []
# Should render a special list value:
    assert_select 'div.review-group > div.review-list', :text => '(none)'
  end

  test "if message is empty" do
    render_partial %w[abc def], ''
# Should remder the empty message:
    assert_select 'div.review-group > div.review-message', :text => ''
  end

  test "if both list and message are empty" do
    render_partial [], ''
# Should render a special list value:
    assert_select (s='div.review-group > div.review-')+'list', :text => '(none)'
# Should remder the empty message:
    assert_select s+'message', :text => ''
  end

#-------------
  private

  def happy_path
    render_partial Picture.find :all
  end

  def render_partial(l,m='a')
    @group=Struct.new(:list,:message).new l, m
    super 'sessions/review_group', :review_group => @group
  end

end
