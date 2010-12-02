require 'test_helper'

class ShowSessionsTemplateTest < SharedViewTest

  test "happy path..." do
# Should render:
    assert_template @template
  end

#-------------
  private

  def setup
    if @template.blank?
      @template='sessions/show'
      render :template => @template
    end
  end

end
