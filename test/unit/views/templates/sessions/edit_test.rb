require 'test_helper'

class EditSessionsTemplateTest < SharedViewTest

  test "happy path should render..." do
# The right template:
    assert_template @template
    s='sessions/_'
# A single approval group:
    assert_partial s+'approval_group', 1
# The right number of review groups:
    assert_partial s+'review_group', @review_groups.length
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
