require 'test_helper'

class FilePasswordTest < ActiveSupport::TestCase
  test "connection should be nulldb" do
      # Needed to run:
      # gem install activerecord-nulldb-adapter
      # rails plugin install git://github.com/nulldb/nulldb.git

      assert_equal ActiveRecord::ConnectionAdapters::NullDBAdapter,
        FilePassword.connection.class
      assert_equal 'NullDB', FilePassword.connection.adapter_name
  end

  test "find should call MyFile" do
    f = File.new("#{Rails.root}"\
      '/test/unit/files/file_passwords/password.txt', 'r')
    MyFile.expects(:my_new).returns(f)
    FilePassword.find :all
  end

  test "find should use right password file" do
    f = File.new("#{Rails.root}"\
      '/test/unit/files/file_passwords/password.txt', 'r')
    MyFile.expects(:my_new).with("#{Rails.root}"\
      '/../gallery-webmaster/password.txt', 'r').returns(f)
    FilePassword.find :all
  end

  test "find should close password file" do
    f = File.new("#{Rails.root}"\
      '/test/unit/files/file_passwords/password.txt', 'r')
    f.expects(:close)
    MyFile.expects(:my_new).returns(f)
    FilePassword.find :all
  end    

  test "password should be the test one" do
    # NOT Needed a file in config/initializers (I created fix-nulldb.rb)
    # and put in it:
    # ActiveRecord::Base.establish_connection :adapter => :nulldb

    f = File.new("#{Rails.root}"\
      '/test/unit/files/file_passwords/password.txt', 'r')
    MyFile.expects(:my_new).returns(f)
    assert_equal 'abc', FilePassword.find(:all).first.password
  end

  test "password file should be read" do
    f = File.new("#{Rails.root}"\
      '/test/unit/files/file_passwords/password.txt', 'r')
    a = f.readlines
    MyFile.expects(:my_new).returns f
    f.expects(:readlines).returns a
    assert_equal 'abc', FilePassword.find(:all).first.password
  end

end
