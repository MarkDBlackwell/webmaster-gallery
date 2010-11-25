class SharedControllerTest < ActionController::TestCase

  private

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

  def filter_chain
    @controller._process_action_callbacks
  end

  def get_password
    f=File.new("#{Gallery::Application.config.webmaster}/password.txt", 'r')
    result = f.readline("\n").chomp "\n"
    f.close
    result
  end

  def pretend_logged_in
    session[:logged_in]=true
    set_cookies
  end

  def restful_methods
    {
        :index   => :GET,
        :new     => :GET,
        :create  => :POST,
        :edit    => :GET,
        :update  => :PUT,
        :show    => :GET,
        :destroy => :DELETE,
        }
  end

  def set_cookies
    request.cookies[:not_empty]='not_empty'
  end

  def self.test_cookies_blocked(a)
    a.each do |action|
      test "#{action} should flash if cookies (session store) blocked even "\
           "if already logged in" do
        pretend_logged_in
        request.cookies.clear
        process action, {:id => '2'}, {:password => get_password}, nil,
            restful_methods.fetch(action).to_s
        assert_select 'div.error', 'Cookies required, or session timed out.'
      end
#      test "#{action} should not flash so, if cookies not blocked" do
#        login
#        assert_select 'div.notice', 0
#        assert_select 'div.error', 0
#      end
    end
  end

  def try_wrong_methods(action, options=nil, params=nil)
# Reference: 'ActionController - PROPFIND and other HTTP request methods':
# at http://railsforum.com/viewtopic.php?id=30137
    should_redirect = {:controller => :sessions, :action => :new}
    (ActionController::Request::HTTP_METHODS - [restful_methods.fetch(action).
        to_s]).each do |bad_method|
      pretend_logged_in
      process action, options, params, nil, bad_method
      assert_redirected_to should_redirect, bad_method
    end
  end

end
