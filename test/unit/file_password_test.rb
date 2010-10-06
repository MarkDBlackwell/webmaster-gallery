require 'test_helper'

class FilePasswordTest < ActiveSupport::TestCase
  test "connection should be nulldb" do
      # Needed to run:
      # gem install activerecord-nulldb-adapter
      # rails plugin install git://github.com/nulldb/nulldb.git

      assert_equal ActiveRecord::ConnectionAdapters::NullDBAdapter,
        FilePassword.connection.class
  end

end
