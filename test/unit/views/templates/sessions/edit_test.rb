require 'test_helper'

class EditSessionsTemplateTest < SharedViewTest

# Working_on

  test "happy path..." do
# Should render:
    assert_template @template
# Should render review groups:
    assert_partial 'sessions/_review_group', @review_groups.length
# Should render an approval div:
    assert_select 'div.approve', 1, 'div.approve'
# Should render a single form:
    assert_select 'div.approve > form', 1, (s='form')
    assert_select 'form', 1, s do
# Should render an approval form:
      assert_select 'form[method=post]', 1, s
      assert_select 'form[action=/session]', 1, s
# Approval form should indicate the method, 'put':
      assert_select 'form > div > input[type=hidden][name=_method]', 1,
          (s='put') do
        assert_select 'input[value=put]', 1, s
      end
# Approval form should include an approval group...:
      assert_select 'form > input[type=hidden]', 1, (s='approval') do
        assert_select 'input[name=approval_group]', 1, s
        assert_select 'input[  id=approval_group]', 1, s
# which should contain the appropriate contents:
        assert_select 'input[value=?]', @approval_group.list.join(' ')
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
      s=Struct.new(:list,:message)
      @review_groups=[
          s.new( %w[aaaa bbb], 'hello'),
          s.new(Tag.    find(:all), ''),
          s.new(Picture.find(:all), '')]
      @approval_group=
          s.new  %w[eeee fff], 'hello'
      @template='sessions/edit'
      render :template => @template
    end
  end

end
