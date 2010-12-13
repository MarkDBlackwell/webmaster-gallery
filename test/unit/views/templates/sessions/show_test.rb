require 'test_helper'

class ShowSessionsTemplateTest < SharedViewTest

  test "happy path..." do
# Should render the right template:
    assert_template @template
# Should render a single review group:
    assert_partial 'sessions/_review_group', 1
  end

#-------------
  private

  def setup
    if @template.blank?
      @review_group=(Struct.new :list, :message).new []
      render :template => (@template='sessions/show')
    end
  end

end
