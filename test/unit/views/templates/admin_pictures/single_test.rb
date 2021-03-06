require 'test_helper'

class SingleAdminPicturesTemplateTest < SharedViewTest
# %%vi%%temp%%adm%%si

  test "happy path should render..." do
# TODO: Pretty html source:
#    check_pretty_html_source
# The right template:
    assert_template @template
# A single picture:
    assert_partial 'pictures/_picture', 1
# The right picture:
    assert_single [(CssString.new('div').css_class 'picture'),'id'],
        'picture_'+@picture.id.to_s
  end

#-------------

  def setup
    if @template.blank?
      @link_controller=:admin_pictures
      @picture=pictures :two
      @template='admin_pictures/single'
      render :template => @template
    end
  end

end
