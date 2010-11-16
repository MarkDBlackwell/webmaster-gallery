require 'test_helper'
should_include_this_file

class AdminPicturesTemplateTest < ActionView::TestCase
  helper PicturesHelper

  test "views should include something" do
    %w[index single].each do |view|
      @pictures=Picture.all
      @picture=Picture.first
      render :template => "admin_pictures/#{view}"
      assert_select 'div.gallery', 1, "Action #{view}"
#      assert_template({:template => "admin_pictures/#{view}"}, "View #{view}")
    end
  end

end
