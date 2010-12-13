require 'test_helper'

class SingleAdminPicturesTemplateTest < SharedViewTest

  test "happy path..." do
# TODO: Should render pretty html source:
#    check_pretty_html_source
# Should render the right template:
    assert_template @template
# Should render a single picture:
    assert_select (s='div.picture'), 1
    assert_partial 'pictures/_picture', 1
# Should render the right picture:
    assert_select "#{s}[id=picture_#{@picture.id}]"
  end

#-------------
  private

  def setup
    if @template.blank?
      @picture=pictures :two
      @template='admin_pictures/single'
      render :template => @template
    end
  end

end
