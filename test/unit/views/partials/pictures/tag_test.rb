require 'test_helper'

class TagPicturesPartialTest < SharedPicturesPartialTest

  test "should render pretty html source" do
    check_pretty_html_source nil, 'tag'
  end

  test "tag partial..." do
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
