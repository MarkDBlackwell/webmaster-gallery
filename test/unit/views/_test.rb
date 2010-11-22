require 'test_helper'

class ViewsTest < ActionView::TestCase

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
    test "multiple tests using the same block parameter name should fail" do
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
