require 'test_helper'

class ReviewGroupSessionsPartialTest < SharedPartialTest

# Working_on

  test "happy path..." do
    happy_path
# Should render the right partial:
    assert_partial
    assert_select 'div.review-group', 1 do
# Should render the right message:
      assert_select 'div.review-group > div.review-message', 1
      assert_select 'div.review-message', 1
      assert_select 'div.review-message', :text => @group.message
# Should sort and render the right picture filenames:
      assert_select 'div.review-group > div.review-list', 1
      assert_select 'div.review-list', 1
      assert_select 'div.review-list', :text => @group.list.map(&:filename).
          sort.join(' ')
    end
  end

  test "if list is not of a model" do
    render_partial %w[def abc]
# Should sort and render the list itself:
    assert_select 'div.review-group > div.review-list', :text =>
        @group.list.sort.join(' ')
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
    assert_select 'div.review-group > div.review-list', :text => '(none)'
# Should remder the empty message:
    assert_select 'div.review-group > div.review-message', :text => ''
  end

#-------------
  private

  def happy_path
    render_partial Picture.find :all
  end

  def render_partial(l,m='a')
    @group=(g=Struct.new(:list,:message).new l, m)
    super 'sessions/review_group', :review_group => g
  end

end
