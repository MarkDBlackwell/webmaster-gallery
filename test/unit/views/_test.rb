require 'test_helper'

class ViewsTest < SharedViewTest
# %%vi%%all

  test "should allow mocking with Mocha" do
# Needed 'rails plugin install git://github.com/floehopper/mocha.git
# Do not use this (next line) in Gemfile:
# gem 'mocha' # Broke the test somehow.
    mock 'A'
  end

#-------------
# Alert me tests:

# TODO: add these:
# These argument parentheses confuse the parser:
## m(o.m(v,v).m(v,v), 1,  [v,v].join v) do
## m(o.m(v,v).m(v,v), 1, ([v,v].join v) do

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
    assert_raise(NoMethodError){ActionView::TestCase.assert_partial() }
    assert_raise(NoMethodError){render_partial() }
# When things work:
# Fixtures :all:
    assert_raise(StandardError){pictures :all}
# Testing a partial was rendered with the right locals, (i.e., a bug is fixed
# in assert_template (lines 99-102):
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
    touch_picture_files ['two-t.png']
    render 'pictures/thumbnail', :picture => (pictures :two)
    partial_assertions
  end

  test "alert me (partial, both keywords)..." do
    touch_picture_files ['two-t.png']
    render :partial => 'pictures/thumbnail', :locals => {:picture =>
        (pictures :two)}
    partial_assertions
  end

#-------------
  private

  def partial_assertions
# TODO: How can I tell when Rails implements this (string without '_')?:
##   assert_template :partial => 'pictures/thumbnail'
    @s1,@s2,@s3 = %w( pictures/_thumbnail  [alt=?]  two-title )
    [false,0].each do |c| # Count.
# When Rails enables these semantics and finds a...:
# Partial:
      assert_template @s1, c
      assert_template({:partial => @s1}, c)
# Attribute selector, with option count:
      assert_select @s2, {:count => c}, c
# Attribute selector, with options text & count:
      assert_select @s2, {:text => @s3}, c
      assert_select @s2, {:text => @s3, :count => false}, c
      assert_select @s2, {:text => @s3, :count => 0}, c
      assert_select @s2, {:text => @s3, :count => 1}, c
    end
    these_semantics_work
    delete_picture_files
    @s1,@s2,@s3=nil
  end

## base_uri
## gallery_directory
## gallery_uri
## static_asset_matcher
  def these_semantics_work
    assert_template :partial => @s1, :count => 1
    assert_select 'div.thumbnail', 1
    assert_select @s2, @s3, 1
    r=filename_matcher 'two-t.png'
    assert_select '[src=?]', r, 1
  end

end
