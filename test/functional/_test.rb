require 'test_helper'

class AllControllerTest < ActionController::TestCase

  test "should allow mocking with Mocha" do
# Needed 'rails plugin install git://github.com/floehopper/mocha.git
# Do not use this (next line) in Gemfile:
# gem 'mocha' # Broke the test somehow.
    mock 'A'
  end

  test "alert me when Rails re-supports this method" do
    assert_raise NoMethodError do
      filter_chain()
    end
  end

end
