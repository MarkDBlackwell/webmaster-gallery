require 'test_helper'

class FilePasswordTest < ActiveSupport::TestCase
  test "should connect to NullDB" do
      # Needed to run:
      # gem install activerecord-nulldb-adapter
      # rails plugin install git://github.com/nulldb/nulldb.git

      assert_equal 'NullDB', FilePassword.connection.adapter_name
      assert_equal ActiveRecord::ConnectionAdapters::NullDBAdapter,
        FilePassword.connection.class
  end

  test "find should invoke MyFile" do
    mock_file
    find
  end

  test "should open the correct password file" do
    mock_file.with("#{Rails.root}"\
      '/../gallery-webmaster/password.txt', 'r')
    find
  end

  test "should close the password file" do
    @f.expects :close
    mock_file
    find
    @f = nil # Reset for teardown.
  end    

  test "should read the password file" do
    a = @f.readlines
    mock_file
    @f.expects(:readlines).returns a
    find
  end

  test "should obtain the test password" do
    mock_file
    clear_text_password = @f.readlines.first.chomp
    @f.rewind
    assert_equal clear_text_password, find.first.password
  end

  test "should find one row" do
    mock_file
    assert_equal 1, find.to_a.size
  end

  test "a find without all should raise a model exception" do
    begin
      FilePassword.find
      flunk
    rescue FilePassword::FindError
    end
  end

  private

  def setup
    @f = File.new("#{Rails.root}"\
      '/test/fixtures/files/file_password/password.txt', 'r')
  end

  def teardown
    @f.close unless @f.nil? || @f.closed?
  end

  def mock_file
    MyFile.expects(:my_new).returns @f
  end

  def find
    FilePassword.find :all
  end

end
