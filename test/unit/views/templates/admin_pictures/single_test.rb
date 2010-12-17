require 'test_helper'

class SingleAdminPicturesTemplateTest < SharedViewTest

  test "happy path should render..." do
# TODO: Pretty html source:
#    check_pretty_html_source
# The right template:
    assert_template @template
# A single picture:
    dp=CssString.new('div').css_class 'picture'
    assert_partial 'pictures/_picture', 1
# The right picture:
    assert_select dp.attribute 'id', 'picture_'+@picture.id.to_s
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
