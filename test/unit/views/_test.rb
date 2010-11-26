require 'test_helper'

class ViewsTest < ActionView::TestCase

#pretty html

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

end
