require 'test_helper'

class SingleSessionsTemplateTest < SharedViewTest
# %%vi%%temp%%ses%%si

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

  def setup
    s=Struct         .new   :list,    :message
    @approval_group=s.new %w[fff ee], 'something'
    @review_groups=[(a=s.new []),a]
    @erroneous=[]
    render :template => (@template='sessions/single')
  end

end
