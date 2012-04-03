require 'test_helper'

class MochaTest < ActionView::TestCase
# %%all

  test "should allow mocking with Mocha" do
# Needed 'rails plugin install git://github.com/floehopper/mocha.git
# Do not use this (next line) in Gemfile:
# gem 'mocha' # Broke the test somehow.
# Unsure about Rails 3.
    "a".expects(:some_method).never
  end

end
