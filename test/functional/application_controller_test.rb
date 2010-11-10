require 'test_helper'

class ApplicationControllerTest < ActionController::TestCase

  test "should include this file" do
#    flunk
  end

  test "should allow mocking with Mocha" do
# Needed 'rails plugin install git://github.com/floehopper/mocha.git
# Do not use this (next line) in Gemfile:
# gem 'mocha' # Broke the test somehow.
    mock 'A'
  end

  test "filters should include guard http method" do
    assert_filter :guard_http_method
  end

  test "filters should include guard logged in" do
    assert_filter :guard_logged_in
  end

  test "filters should include verify authenticity token" do
    assert_filter :verify_authenticity_token
  end

end
