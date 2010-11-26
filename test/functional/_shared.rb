class SharedControllerTest < ActionController::TestCase

  private

  RESTFUL_METHODS={
      :index   => :GET,
      :new     => :GET,
      :create  => :POST,
      :edit    => :GET,
      :update  => :PUT,
      :show    => :GET,
      :destroy => :DELETE,
      }

  def assert_blank_assigns(symbol)
    assert_blank assigns(symbol), "@#{symbol}"
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

  def filter_chain
    @controller._process_action_callbacks
  end

  def get_password
    if @_password.blank?
      f=File.new("#{Gallery::Application.config.webmaster}/password.txt", 'r')
      @_password=f.readline("\n").chomp "\n"
      f.close
    end
    @_password
  end

  def pretend_logged_in
    session[:logged_in]=true
    set_cookies
  end

  def set_cookies
    request.cookies[:not_empty]='not_empty'
  end

  def self.test_should_render_session_buttons(a)
    a.each_with_index do |action,i|
      test "get #{action} should render session buttons" do
# TODO: Add similar tests for styles, messages & action content divs.
# TODO: Or, move to an application layout test.
        pretend_logged_in
        get action, :id => pictures(:two).id
        assert_blank_assigns :suppress_buttons
        assert_select 'div.session-buttons', 1
        assert_template :partial => 'application/_buttons', :count => 1
      end
    end
  end

  def self.test_cookies_blocked(a)
    a.each do |action|
      test "#{action} should flash if cookies (session store) blocked even "\
           "if already logged in" do
        pretend_logged_in
        request.cookies.clear
        process action, {:id => '2'}, {:password => get_password}, nil,
            RESTFUL_METHODS.fetch(action).to_s
        assert_select 'div.error', 'Cookies required, or session timed out.'
      end
    end
  end

  def self.test_happy_path_response(action=nil)
    test "happy path" do
      happy_path
      if action.present?
        assert_redirected_to :action => action
      else
        assert_response :success
      end
    end
  end

  def self.test_if_not_logged_in_redirect_from(a)
    a.each do |action|
      test "#{action} should redirect to sessions new if not logged in" do
        pretend_logged_in
        session[:logged_in]=nil
        process action, {:id => '2'}, nil, nil, RESTFUL_METHODS.fetch(action
            ).to_s
        assert_redirected_to :controller => :sessions, :action => :new
      end
    end
  end

  def self.test_wrong_http_methods(a)
# Reference: 'ActionController - PROPFIND and other HTTP request methods':
# at http://railsforum.com/viewtopic.php?id=30137
    should_redirect = {:controller => :sessions, :action => :new}
    (a.kind_of?(Array) ? a : [a]).each do |action|
      (ActionController::Request::HTTP_METHODS - [RESTFUL_METHODS.fetch(action).
          to_s]).each do |bad_method|
        test "#{action} should redirect to sessions new on wrong http method "\
             "#{bad_method}" do
          pretend_logged_in
          process action, {:id => '2'}, nil, nil, bad_method
          assert_redirected_to should_redirect, bad_method
        end
      end
    end
  end

end
