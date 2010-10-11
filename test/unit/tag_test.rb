require 'test_helper'

class TagTest < ActiveSupport::TestCase
  fixtures :tags, :file_tags

  test "find all" do
    print Tag.find(:all).length
  end
end
