require 'test_helper'

class AdminPicturesHelperTest < ActionView::TestCase

  test "should include this file" do
#    flunk
  end

  test "should be no AdminPictures helpers, or write tests" do
    f=File.open("#{Rails.root}/app/helpers/admin_pictures_helper.rb",'r')
    assert_equal ["module AdminPicturesHelper\n","end\n"], f.readlines
    f.close
  end

end
