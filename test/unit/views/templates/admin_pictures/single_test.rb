require 'test_helper'

class SingleAdminPicturesTemplateTest < SharedViewTest

  test "should render" do
    assert_template @template
  end

  test "should render pretty html source" do
    check_pretty_html_source
  end

  test "should render a single picture" do
    assert_select 'div.picture', 1
    assert_template :partial => 'pictures/_picture', :count => 1
  end

  test "should render the right picture" do
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
