require 'test_helper'

class EditSessionsTemplateTest < SharedViewTest

  test "happy path..." do
# Should render the right template:
    assert_template @template
# Should render a single approval group:
    assert_partial 'sessions/_approval_group', 1
# Should render the right number of review groups:
    assert_partial 'sessions/_review_group', @review_groups.length
  end

#-------------
  private

  def setup
    s=Struct         .new   :list,    :message
    @approval_group=s.new %w[fff ee], 'something'
    @review_groups=[(a=s.new []),a]
    render :template => (@template='sessions/edit')
  end

end
