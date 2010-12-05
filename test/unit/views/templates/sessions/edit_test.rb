require 'test_helper'

class EditSessionsTemplateTest < SharedViewTest

  test "happy path..." do
# Should render:
    assert_template @template
# Should render review groups:
    assert_partial 'sessions/_review_group', @review_groups.length
# Should render an approval div:
    assert_select 'div.approve', 1
# Should render a single form:
    assert_select 'div.approve > form', 1
    assert_select 'form', 1 do
# Should render an approval form:
      assert_select 'form[method=get]', 1
      assert_select 'form[action=/session]', 1
# Approval form should include an approval group...:
      assert_select 'form > input[type=hidden]', 1 do
        assert_select 'input[name=approval_group]', 1
        assert_select 'input[  id=approval_group]', 1
# which should contain the appropriate contents:
        assert_select 'input[value=?]', @approval_group.join(' ')
      end
# Approval form should include a submit button:
      assert_select 'form > input[type=submit]', 1 do
# on which should be appropriate text:
        assert_select 'input[value=approve]', 1
      end
    end
# Should render a single submit button:
    assert_select 'input[type=submit]', 1
  end

#-------------
  private

  def setup
    if @template.blank?
      s=Struct.new(:list,:message)
      @review_groups=[
          s.new(%w[aaa bbb],'hello'  ),
          s.new(Tag.    find(:all),''),
          s.new(Picture.find(:all),'')]
      @approval_group = %w[eeee ffff]
      @template='sessions/edit'
      render :template => @template
    end
  end

end
