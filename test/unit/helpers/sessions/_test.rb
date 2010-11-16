require 'test_helper'

class SessionsHelperTest < ActionView::TestCase

  test "should include this file" do
#    flunk
  end

  test "should be no Sessions helpers, or write tests" do
    f=File.open("#{Rails.root}/app/helpers/sessions_helper.rb",'r')
    assert_equal ["module SessionsHelper\n","end\n"], f.readlines
    f.close
  end

end
