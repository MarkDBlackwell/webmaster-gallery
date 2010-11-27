require 'test_helper'

class IndexAdminPicturesTemplateTest < SharedViewTest

  test "should render" do
    assert_template @template
  end

  test "should render pretty html source" do
    check_pretty_html_source
  end

  test "should render a gallery, once" do
    assert_template :partial => 'pictures/_gallery', :count => 1
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
