require 'test_helper'

class TagPicturesPartialTest < SharedPicturesPartialTest

  test "happy path..." do
# Should render pretty html source:
    check_pretty_html_source nil, 'tag'
# Should render:
    assert_template :partial => 'pictures/_tag', :count => 1
# Should include one tag div:
    assert_select 'div.tag', 1
  end

#-------------
  private

  def setup
    tag=tags(:two)
    render :partial => 'pictures/tag', :locals => {:tag => tag}
  end

end
