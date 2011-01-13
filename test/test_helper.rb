ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
REQUIRE_TEST_BASENAME='_shared.rb'
paths=[]
App.root.join('test').find do |path|
  b=path.basename.to_s
  Find.prune if path.directory? && ?.==b[0]
  paths << path.dirname.join(b.chomp '.rb') if REQUIRE_TEST_BASENAME==b
end
paths.sort.each{|e| require e}

class ShouldIncludeThisFileLog
  PREFIX='./test/'
  THIS=PREFIX + Pathname(__FILE__).basename.to_s
  def self.add
    unless @log.present?
      @previous='no-such'
      f=App.root.join 'out/test-should-include-this-file.log'
      FileUtils.rm  f, :force => true
      @log=ActiveSupport::BufferedLogger.new f
    end
    a=caller(0)
    i=a.index do |e|
        e.start_with?(PREFIX   ) &&
      ! e.start_with?(THIS     ) &&
      ! e.start_with?(@previous)
    end
    unless i.blank?
      s=a.at(i)
      @previous=s.slice(0..s.index(?:))
      @log.add(Logger::DEBUG,@previous)
    end
  end
end

class Object
  def require_with_test_logging(*args)
    ShouldIncludeThisFileLog.add
    require_without_test_logging(*args)
  end
  alias_method_chain :require, :test_logging
end

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

#-------------
  private

  def construct_changes_strings(model,operation,count=1)
    expected=model_names model
    case operation
    when 'delet' then changed=expected.pop count
    when 'add'
      changed=series "three#{ 'picture'==model ? '.png' : '-name' }", count
      expected=expected.take(count).concat changed
    end
    [expected,changed]
  end

  def mock_directory_picture_bad_names(expected)
    DirectoryPicture.expects(:find_bad_names).returns expected.sort.reverse
  end

  def mock_directory_pictures(expected=:all)
    mock_model DirectoryPicture, :filename, expected
  end

  def mock_expected(model,expected)
    other='tag'==model ? [] : :all
    t,p  ='tag'==model ? [expected,other] : [other,expected]
    mock_file_tags          t
    mock_directory_pictures p
    mock_unpaired_names []
  end

  def mock_file_tag_bad_names(expected)
    FileTag.expects(:find_bad_names).returns expected.sort.reverse
  end

  def mock_file_tags(expected=:all)
    mock_model FileTag, :name, expected
  end

  def mock_model(model,method,expected)
    expected=case
# See ActiveRecord::Base method, '==='. Another way is to use object_id:
    when DirectoryPicture==model then Picture
    when FileTag         ==model then Tag
    end.find(:all).map &method if :all==expected
    model.expects(:find).at_least_once.returns(expected.sort.reverse.
        map{|e| (p=model.new).expects(method).at_least_once.returns e; p} )
  end

  def mock_unpaired_names(expected)
    DirectoryPicture.expects(:find_unpaired_names).at_least_once.returns(
        expected.sort.reverse)
  end

  def model_names(model)
    model.capitalize.constantize.find(:all).
        map &"#{ 'file' if 'picture'==model }name".to_sym
  end

  def see_output(s=nil)
    a = %w[rendered response].map{|e|(!respond_to? e) ? nil : (send e)}
    a.push(a.pop.body) if a.last
    (a.unshift s).compact!
    assert_present a, 'nothing defined'
    f=App.root.join('out/see-output').open 'w'
    f.print a.first
    f.close
  end

  def series(start,count=1)
    o=object=nil
    Array.new(count){o=o.blank? ? start : o.succ}
  end

end
