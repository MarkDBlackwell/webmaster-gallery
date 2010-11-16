ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
Find.find("#{Rails.root}/test") do |path|
  b=File.basename(path)
  Find.prune if FileTest.directory?(path) && ?.==b[0]
  require File.expand_path(path.chomp('.rb'),'/') if 'shared.rb'==b
end

class Object
  def should_include_this_file
    f=File.new("#{Rails.root}/out/test-should-include",'a')
    f.print "#{caller.first}\n"
    f.close
  end
end

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

#-------------
  private

  def assert_after_filter(*args)
    assert_filter_kind(:after,*args)
  end

  def assert_filter(*args)
    assert_filter_kind(:before,*args)
  end

  def assert_filter_kind(kind,filter,sa=nil)
    if sa.blank?
      skip_actions = []
    else
      sa=[sa] unless sa.kind_of?(Array)
      skip_actions=[sa.collect {|e| "action_name == '#{e}'"}.join(' || ')]
    end
    desired=[filter, filter, kind, skip_actions]
    ours=['ApplicationController',self.class.to_s.chomp('Test')].
        collect do |class_name|
      filter_chain.select {|e| e.klass.to_s==class_name}
    end.flatten(1)
    have=ours.collect {|e| [e.raw_filter, e.filter, e.kind, e.per_key.fetch(
        :unless)]}
    assert have.include?(desired), [
        'Found:', have.collect {|e| e.uniq.inspect},
        'Desired:', [filter,kind,sa].collect {|e| e.inspect}.join(', '),
        ].join("\n")
  end

  def assert_select_include?(css, string)
    assert_select css, Regexp.new(Regexp.escape string)
  end

  def filter_chain
    assert_raise(NoMethodError) {super} # Notice if Rails re-supports this method.
    @controller._process_action_callbacks
  end

  def pretend_logged_in
    session[:logged_in]=true
    set_cookies
  end

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

  def try_wrong_methods(actions, options=nil, params=nil)
# Reference: 'ActionController - PROPFIND and other HTTP request methods':
# at http://railsforum.com/viewtopic.php?id=30137
    should_redirect = {:controller => :sessions, :action => :new}
    restful_methods = {
        :index   => :get,
        :new     => :get,
        :create  => :post,
        :edit    => :get,
        :update  => :put,
        :show    => :get,
        :destroy => :delete,
        }
    actions.each do |action|
      (ActionController::Request::HTTP_METHODS - [restful_methods.fetch(action).
          to_s]).each do |bad_method|
        pretend_logged_in
        process action, options, params, nil, bad_method
        assert_redirected_to should_redirect,
            "Action #{action}, method #{bad_method}."
      end
    end
  end

end
