require 'test_helper'

class EditSessionsTemplateTest < SharedViewTest

  test "happy path..." do
    @review_groups=[]
    @approval_group=nil
# Should render:
    assert_template @template
# Should render difference, once:
    assert_partial 'sessions/_review_group', 1
  end

#-------------
  private

  def setup
    if @template.blank?
      @template='sessions/edit'
      render :template => @template
    end
  end

end
