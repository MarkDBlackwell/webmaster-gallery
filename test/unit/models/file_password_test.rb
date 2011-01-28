require 'test_helper'

class FilePasswordTest < ActiveSupport::TestCase
# %%mo%%fpas

#TODO: possibly use https://github.com/rails/rails/blob/master/actionpack/lib/action_view/testing/resolvers.rb

#-------------
# All methods tests:

#  test "should connect to NullDB" do
# Needed to run:
# gem install activerecord-nulldb-adapter
# rails plugin install git://github.com/nulldb/nulldb.git
# But, as of 2010 Oct 11, the latest version (both 0.2.1) broke fixture
# processing in other models, even with (in app/models/file_password.rb):
# FilePassword.establish_connection :adapter => :nulldb
# For now, decided not to use NullDB.
#
#    assert_equal 'NullDB', FilePassword.connection.adapter_name
#    assert_equal ActiveRecord::ConnectionAdapters::NullDBAdapter,
#      FilePassword.connection.class
#  end

#-------------
# Find method tests:

  test "find should invoke MyFile" do
    mock_file
    find
  end

  test "find should open the correct password file" do
    mock_file.with @pathname, 'r'
    find
  end

  test "find should close the password file" do
    @f.expects :close
    mock_file
    find
    @f=nil # Reset for teardown.
  end    

  test "find should read the password file" do
    a=clear_text_password + "\n"
    mock_file
    @f.expects(:readline).returns a
    find
  end

  test "find should obtain the test password" do
    mock_file
    a=clear_text_password
    @f.rewind
    assert_equal a, find.first.password
  end

  test "should find one row" do
    mock_file
    assert_equal 1, find.to_a.length
  end

  test "a find without all should raise a model exception" do
    assert_raise FilePassword::FindError do
      FilePassword.find
    end
  end

  test "in find, a too-short password should have an error" do
    short=clear_text_password.slice(0..8) + "\n"
    @f.rewind
    mock_file
    @f.expects(:readline).returns short
    first=FilePassword.first
    assert_equal true, first.invalid?
    assert_equal ['Password too short'], first.errors.full_messages
  end

#-------------
  private

  def clear_text_password
    @f.readline("\n").chomp "\n"
  end

  def find
    FilePassword.all
  end

  def mock_file
    MyFile.expects(:my_new).returns @f
  end

  def setup
    @pathname=App.webmaster.join 'password.txt'
    @f=@pathname.open 'r'
  end

  def teardown
    @f.close unless @f.blank? || @f.closed?
  end

end
