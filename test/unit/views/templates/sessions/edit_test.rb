require 'test_helper'

class EditSessionsTemplateTest < SharedViewTest

  test "happy path..." do
# Should render:
    assert_template @template
# Should render review- and approval groups:
    assert_partial 'sessions/_review_group', 1 + @review_groups.length
# Should render an approval div:
    assert_select 'div.approve', 1
# Should render a single form:
    assert_select 'div.approve > form', 1
    assert_select 'form', 1 do
# Should render an approval form:
      assert_select 'form[method=get]', 1
      assert_select 'form[action=/session]', 1
# Approval form should include a submit button:
      assert_select 'form > input[type=submit]', 1
    end
# Should render a single submit button, which...
    assert_select 'input[type=submit]', 1 do
# should display appropriate text:
      assert_select 'input[value=approve]', 1
    end
  end

#-------------
  private

  def setup
    if @template.blank?
#      @approval_group=t=Tag.find(:all).map(&:name)
#      p=Picture.find(:all).map(&:filename)
      @approval_group=t=Tag.find(:all)
      p=Picture.find(:all)
      @review_groups=[t,p]
      @template='sessions/edit'
      render :template => @template
    end
  end

end
