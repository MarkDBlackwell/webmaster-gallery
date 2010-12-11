require 'test_helper'

class ShowSessionsTemplateTest < SharedViewTest

  test "happy path..." do
# Should render:
    assert_template @template
  end

#-------------
  private

  def setup
    render :template => (@template='sessions/show') if @template.blank?
  end

end
