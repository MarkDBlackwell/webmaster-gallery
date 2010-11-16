require 'test_helper'
should_include_this_file

class AdminPicturesHelperTest < ActionView::TestCase

  test "should be no AdminPictures helpers, or write tests" do
    f=File.open("#{Rails.root}/app/helpers/admin_pictures_helper.rb",'r')
    assert_equal ["module AdminPicturesHelper\n","end\n"], f.readlines
    f.close
  end

end
