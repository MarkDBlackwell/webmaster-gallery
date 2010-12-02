require 'test_helper'

class IndexAdminPicturesTemplateTest < SharedViewTest

  test "happy path..." do
# Should render pretty html source:
    check_pretty_html_source
# Should render:
    assert_template @template
# Should render a gallery, once:
    assert_partial 'pictures/_gallery', 1
  end

#-------------
  private

  def setup
    if @template.blank?
      @template='admin_pictures/index'
      render :template => @template
    end
  end

end
