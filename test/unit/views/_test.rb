require 'test_helper'

class ViewsTest < ActionView::TestCase

  test "should allow mocking with Mocha" do
# Needed 'rails plugin install git://github.com/floehopper/mocha.git
# Do not use this (next line) in Gemfile:
# gem 'mocha' # Broke the test somehow.
    mock 'A'
  end

# Test of multiple tests:
  %w[abc def ghi].each do |s|
    case s
    when 'abc'
      test "multiple tests (#{s}) should work" do
        assert_equal 'abc', s
      end
    when 'ghi'
      test "multiple tests (#{s}) should work" do
        assert_equal 'ghi', s
      end
    when 'def'
      test "multiple tests (#{s}) should work" do
        assert_equal 'def', s
      end
    else
      test "alert me when multiple tests using s, the same block parameter "\
           "name, work" do
        assert_raise RuntimeError do
          %w[bcd].each do |s|
            test "multiple tests (#{s}) should work" do
              assert_equal 'bcd', s
            end
          end
        end
      end
    end
  end

  test "alert me" do
# When this works:
    assert_raise StandardError do
      pictures(:all)
    end

# (Partial-rendering alerts setup):
  @picture=pictures(:two)
  render :partial => 'pictures/thumbnail', :locals => {:picture => @picture}

# When testing, that a partial was rendered with the right locals, works (i.e.,
# when a bug in lines 99-102 of assert_template gets fixed):
    assert_raise NoMethodError do
      assert_template :partial => 'pictures/_thumbnail', :locals => {:picture =>
          @picture}
    end

# When Rails enables these semantics:
    assert_template 'pictures/_thumbnail', 0
    assert_template({:partial => 'pictures/_thumbnail'}, 0)
    assert_select '[alt=?]', {:text => 'two-title'}, 0
    assert_select '[alt=?]', {:text => 'two-title', :count => 1}, 0

# These semantics work:
#    assert_template :partial => 'pictures/_thumbnail', :count => 1
#    assert_select 'div.thumbnail', 1
#    assert_select '[alt=?]', 'two-title', 1
#    assert_select '[src=?]', filename_matcher('two-t.png'), 1
  end

end
