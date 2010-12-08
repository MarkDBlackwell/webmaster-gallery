require 'test_helper'

class EditSessionsTemplateTest < SharedViewTest

  test "happy path..." do
# Should render the right template:
    assert_template @template
# Should render the right number of review groups:
    assert_partial 'sessions/_review_group', @review_groups.length
# Should render an approval div:
    assert_select 'div.approve', 1, 'div.approve'
# Should render a single form:
    assert_select 'div.approve > form', 1, (s='form')
    assert_select 'form', 1, s do
# Should render an approval form:
      assert_select 'form[method=post]', 1, s
      assert_select 'form[action=/session]', 1, s
# Approval form should indicate the http method, 'put':
      assert_select 'form > div > input[type=hidden]'\
                                      '[name=_method]', 1, (s='method') do
        assert_select 'input[value=put]', 1, s
      end
# Approval form should include a hidden input...:
      assert_select 'form > input[type=hidden]', 1, (s='approval') do
        assert_select 'input[name=approval_group]', 1, s
        assert_select 'input[  id=approval_group]', 1, s
# which contains the appropriate, sorted approval group:
        assert_select 'input[value=?]', @approval_group.list.sort.join(' ')
      end
# Approval form should include a submit button...:
      assert_select 'form > input[type=submit]', 1, (s='button') do
# on which should be the appropriate text:
        assert_select 'input[value=?]', @approval_group.message
      end
    end
# Should render a single submit button:
    assert_select 'input[type=submit]', 1, s
  end

#-------------
  private

  def setup
    if @template.blank?
      s=Struct         .new :list,      :message
      @approval_group=s.new %w[fff ee], 'something'
      @review_groups=[(a=s.new([])),a]
      render :template => (@template='sessions/edit')
    end
  end

end
