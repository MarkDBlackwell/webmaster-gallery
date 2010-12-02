require 'test_helper'

class EditSessionsTemplateTest < SharedViewTest

  test "happy path..." do
# Should render:
    assert_template @template
# Should render difference, once:
    assert_partial 'sessions/_difference', 1
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
