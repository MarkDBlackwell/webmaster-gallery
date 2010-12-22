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

  test "alert me..." do
# When Rails implements...:
# My method names:
    assert_raise(NoMethodError){assert_partial() }
    assert_raise(NoMethodError){render_partial() }
# When things work:
# Fixtures :all:
    assert_raise(StandardError){pictures :all}
# Testing a partial was rendered with the right locals, (i.e., a bug is fixed
#     in assert_template (lines 99-102):
    assert_raise NoMethodError do
      assert_template :partial => 'c/_p', :locals => {:a => 'a'}
    end
# TODO: write an alert-me for file rendering:
# (The pictures controller renders the webmaster's html file.)
#    assert_template App.webmaster.join 'page2'
# Fails giving 'Expected no partials to be rendered':
#    assert_template :file => (App.webmaster.join 'page'),
#        :partial => 'pictures/pictures',
#        :locals => {:pictures => assigns(:pictures)}
#        :locals => nil
# TODO: write an alert-me for counting template rendering:
#    render :template => (@template='sessions/edit')
#    assert_template @template, 0
#    assert_template @template, :count => 0
# Fails giving 'Expected no partials to be rendered':
#    assert_template :template => @template, :count => 1
#    assert_template({:template => @template}, 1)
# Set up:
    r=Struct.new(:list,:message).new [],'message'
# When Rails enables these semantics...:
# For partial rendering:
    s='pictures/thumbnail'
    assert_raise ActionView::Template::Error do
      render :partial => s, :picture => pictures 
    end
    assert_raise ActionView::Template::Error do
      render s, :locals => {:picture => (pictures :two)}
    end
    s='sessions/review_group'
    assert_raise(NameError){render s, r}
    assert_raise(ActionView::Template::Error){render s, :object => r}
    assert_raise ActionView::Template::Error do
      render s, locals => {:object => r}
    end
    assert_raise ActionView::Template::Error do
      render s, locals => {:review_group => r}
    end
# Works:
    render s, :review_group => r
  end

  test "alert me (partial, neither keyword)..." do
    render 'pictures/thumbnail', :picture => (pictures :two)
    partial_assertions
  end

  test "alert me (partial, both keywords)..." do
    render :partial => 'pictures/thumbnail', :locals => {:picture =>
        (pictures :two)}
    partial_assertions
  end

#-------------
  private

  def partial_assertions
# TODO: How can I tell when Rails implements this (string without '_')?:
#   assert_template :partial => 'pictures/thumbnail'
# When Rails enables these semantics (and finds a partial):
    s1='pictures/_thumbnail'
    assert_template s1, 0
    assert_template({:partial => s1}, 0)
    s2,s3 = %w.[alt=?]  two-title.
    assert_select s2, {:text => s3}, 0
    assert_select s2, {:text => s3, :count => 0}, 0
    assert_select s2, {:text => s3, :count => 1}, 0
    these_semantics_work
  end

  def these_semantics_work
    assert_template :partial => 'pictures/_thumbnail', :count => 1
    assert_select 'div.thumbnail', 1
    assert_select '[alt=?]', 'two-title', 1
    s=Regexp.escape '/images/gallery/two-t.png?'
    r=Regexp.new %r"\A#{s}\d+\z"
    assert_select '[src=?]', r, 1
  end

end
