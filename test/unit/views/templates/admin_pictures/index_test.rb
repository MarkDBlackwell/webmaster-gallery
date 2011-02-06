require 'test_helper'

class IndexAdminPicturesTemplateTest < SharedViewTest
# %%vi%%temp%%adm%%in

  test "happy path should render..." do
# TODO: Pretty html source:
#    check_pretty_html_source
# The right template:
    assert_template @template
# A gallery, once:
    assert_partial 'pictures/_gallery', 1
  end

#-------------
  private

  def setup
    if @template.blank?
      @link_controller=:admin_pictures
      @template='admin_pictures/index'
      render :template => @template
    end
  end

end
