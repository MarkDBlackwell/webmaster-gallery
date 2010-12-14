require 'test_helper'

class ApprovalGroupSessionsPartialTest < SharedPartialTest

  test "happy path..." do
# Should render the right partial:
    assert_partial
# Should render an approval div:
    assert_select (s1='div.approve'), 1, s1
# Should render a single form:
    assert_select s1+' > form', 1, (s='form')
    assert_select s, 1, s do
# Should render an approval form:
      assert_select s+'[method=post]', 1, s
      assert_select s+'[action=/session]', 1, s
# Approval form should indicate the http method, 'put':
      assert_select 'form > div > input[type=hidden]'\
                                      '[name=_method]', 1, (s='method') do
        assert_select 'input[value=put]', 1, s
      end
# Approval form should include a hidden input...:
      assert_select 'form > input[type=hidden]', 1, (s='approval') do
        assert_select 'input[name=approval_group]', 1, s
        assert_select 'input[  id=approval_group]', 1, s
# Which contains the appropriate approval group:
        assert_select 'input[value=?]', (@group.list.join ' ')
      end
# Approval form should include a submit button...:
      assert_select 'form > input[type=submit]', 1, (s='button') do
# On which should be the appropriate text:
        assert_select 'input[value=?]', @group.message
      end
    end
# Should render a single submit button:
    assert_select 'input[type=submit]', 1, s
  end

#-------------
  private

  def setup
    @group=Struct.new(:list,:message).new %w[fff ee], 'something'
    render_partial 'sessions/approval_group', :approval_group => @group
  end

end
