require 'test_helper'

class SingleAdminPicturesTemplateTest < SharedViewTest

  test "should render pretty html source" do
    check_pretty_html_source
  end

  test "single..." do
# Should render:
    assert_template @template
# Should render a single picture:
    assert_select 'div.picture', 1
    assert_template :partial => 'pictures/_picture', :count => 1
# Should render the right picture:
    assert_select "div.picture[id=picture_#{@picture.id}]"
  end

#-------------
  private

  def setup
    if @template.blank?
      @picture=pictures(:two)
      @template='admin_pictures/single'
      render :template => @template
    end
  end

end
