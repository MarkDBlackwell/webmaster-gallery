require 'test_helper'

class SingleAdminPicturesTemplateTest < SharedViewTest

  test "happy path..." do
# Should render pretty html source:
    check_pretty_html_source
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
