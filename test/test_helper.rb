ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
%w[ unit/helpers/pictures/pictures_private_all_helper
    functional/sessions/sessions_private_all_controller
    ].each do |e|
  require File.expand_path("../#{e}_test", __FILE__)
end

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...

  private

  def assert_before_filter(filter,ua=nil)
    unless_actions=ua.blank? ? [] : [ua.collect {|e|
        "action_name == '#{e}'"}.join(' || ')]
    desired=[filter, filter, :before, unless_actions]
    ours=['ApplicationController',self.class.to_s.chomp('Test')].
        collect do |class_name|
      filter_chain.select {|e| e.klass.to_s==class_name}
    end.flatten(1)
    have=ours.collect {|e| [e.raw_filter, e.filter, e.kind, e.per_key.fetch(
        :unless)]}
    assert have.include?(desired), ["Found:",
        have.collect {|e| e.uniq.inspect},
        "Desired: :#{filter.to_s}, #{ua.inspect}"].join("\n")
  end

  def assert_select_include?(css, string)
    assert_select css, Regexp.new(Regexp.escape string)
  end

  def filter_chain
    assert_raise(NoMethodError) {super} # Notice if Rails re-supports this method.
    @controller._process_action_callbacks
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

  def try_wrong_methods(actions, options=nil, params=nil)

# Reference: 'ActionController - PROPFIND and other HTTP request methods':
# at http://railsforum.com/viewtopic.php?id=30137

    should_redirect = {:controller => :sessions, :action => :new}
    restful_methods = {
        :index   => 'get',
        :new     => 'get',
        :create  => 'post',
        :edit    => 'get',
        :update  => 'put',
        :show    => 'get',
        :destroy => 'delete',
        }
    actions.each do |action|
      (ActionController::Request::HTTP_METHODS - [restful_methods[action]] ).
          each do |bad_method|
        session[:logged_in]=true
        process action, options, params, nil, bad_method
        assert_redirected_to(should_redirect, "Action #{action}, method #{bad_method}.")
      end
    end
  end

end
