require 'test_helper'

class AdminPicturesTemplateTest < ActionView::TestCase
  helper PicturesHelper

  test "should render pretty html source" do
#    check_pretty_html_source
  end

  %w[index single].each do |template|
    test "#{template} should include something" do
      @pictures=Picture.all
      @picture=Picture.first
# Getting a message, 'expected no partials to be rendered'.
#      setup_with_controller
#      render :file => "admin_pictures/#{template}"
#      render :file => "/admin_pictures/#{template}"
#      render :inline => "admin_pictures/#{template}"
#      render :template => "admin_pictures/#{template}"
#      render :template => "admin_pictures/#{template}", :partials => true
#      render :update => "admin_pictures/#{template}"
#      assert_template :template => "admin_pictures/#{template}"

# TODO: try stubbing the controller.

      render :template => "admin_pictures/#{template}"
      n='index'==template ? 2 : 1
      assert_select 'div.picture', n
      assert_template :partial => 'pictures/_picture', :count => n
    end
  end

end
