ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
REQUIRE_TEST_BASENAME='shared.rb'
Find.find("#{Rails.root}/test") do |path|
  b=File.basename(path)
  Find.prune if FileTest.directory?(path) && ?.==b[0]
  require File.expand_path(path.chomp('.rb'),start='/') if
      REQUIRE_TEST_BASENAME==b
end

class ShouldIncludeThisFileLog
  PREFIX='./test/'
  THIS=PREFIX + File.basename(__FILE__)
  def self.add
    unless @log.present?
      @previous='no-such'
      f="#{Rails.root}/log/test-should-include-this-file.log"
      begin;File.delete(f);rescue(Errno::ENOENT);end
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
      @log.add(Logger::DEBUG, @previous)
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

  def see_output(s=nil)
    f=File.new("#{Rails.root}/out/see-output",'w')
    if s.blank?
      begin s=response.body; rescue NameError; end
      begin s=rendered;      rescue NameError; end
    end
    f.print s
    f.close
  end

  def set_cookies
    request.cookies[:not_empty]='not_empty'
  end

end
