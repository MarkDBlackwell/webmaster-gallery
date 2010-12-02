require 'test_helper'

class ViewsTest < ActionView::TestCase

  test "should allow mocking with Mocha" do
# Needed 'rails plugin install git://github.com/floehopper/mocha.git
# Do not use this (next line) in Gemfile:
# gem 'mocha' # Broke the test somehow.
    mock 'A'
  end

#-------------
# Alert me tests:

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

  test "alert me (implementation)..." do
# When Rails implements my method names:
    assert_raise(NoMethodError) {assert_partial() }
    assert_raise(NoMethodError) {render_partial() }
# When fixtures :all works:
    assert_raise(StandardError) {pictures :all}
# When testing, that a partial was rendered with the right locals, works
# (i.e., when a bug in lines 99-102 of assert_template is fixed):
    assert_raise NoMethodError do
      assert_template :partial => 'c/_p', :locals => {:a => 'a'}
    end
# When Rails enables these semantics:
    assert_raise ActionView::Template::Error do
      render 'pictures/thumbnail', :locals => {:picture => pictures(:two)}
    end
    assert_raise ActionView::Template::Error do
      render :partial => 'pictures/thumbnail', :picture => pictures(:two)
    end
  end

  test "alert me (partial, neither keyword)..." do
    render 'pictures/thumbnail', :picture => pictures(:two)
    partial_assertions
  end

  test "alert me (partial, both keywords)..." do
    render :partial => 'pictures/thumbnail', :locals => {:picture =>
        pictures(:two)}
    partial_assertions
  end

#-------------
  private

  def partial_assertions
# How can I tell when Rails implements this (without '_')?:
#   assert_template :partial => 'pictures/thumbnail'
# When Rails enables these semantics (and finds a partial):
    assert_template 'pictures/_thumbnail', 0
    assert_template({:partial => 'pictures/_thumbnail'}, 0)
    assert_select '[alt=?]', {:text => 'two-title'}, 0
    assert_select '[alt=?]', {:text => 'two-title', :count => 0}, 0
    assert_select '[alt=?]', {:text => 'two-title', :count => 1}, 0
    these_work
  end

  def these_work
# (These semantics work):
    assert_template :partial => 'pictures/_thumbnail', :count => 1
    assert_select 'div.thumbnail', 1
    assert_select '[alt=?]', 'two-title', 1
    assert_select '[src=?]', %r:^/images/gallery/two-t.png\?\d+$: , 1
  end

end
