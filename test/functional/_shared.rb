class SharedControllerTest < ActionController::TestCase

  private

  def assert_blank_assigns(symbol)
    assert_blank assigns(symbol), "@#{symbol}"
  end

  def assert_filter(filter)
    assert_filter_kind :before, filter, []
  end

  def assert_filter_kind(kind,filter,sa=nil)
    if sa.blank?
      skip_actions=[]
    else
      sa=[sa] unless sa.kind_of? Array
      skip_actions=[sa.map{|e| "action_name == '#{e}'"}.join ' || ']
    end
    desired=[filter, filter, kind, skip_actions]
    ours=['ApplicationController',(self.class.to_s.chomp 'Test')].
          map do |class_name|
      filter_chain.select{|e| e.klass.to_s==class_name}
    end.flatten 1
    have=ours.map{|e| [e.raw_filter, e.filter, e.kind, e.per_key.fetch(
        :unless)]}
    assert have.include?(desired), ([
        'Found:', have.map{|e| e.uniq.inspect},
        'Desired:', ([filter,kind,sa].map{|e| e.inspect}.join ', '),
        ].join "\n")
  end

  def assert_filter_skips(filter, actions)
    assert_filter_kind :before, filter, actions
  end

  def assert_logged_in
    assert_equal true, session[:logged_in]
  end

  def assert_no_filter(filter)
    assert_no_filter_kind :before, filter
  end

  def assert_no_filter_kind(kind,filter)
    undesired=[filter, filter, kind]
    class_name=self.class.to_s.chomp 'Test'
    ours=filter_chain.select{|e| e.klass.to_s==class_name}
    have=ours.map{|e| [e.raw_filter, e.filter, e.kind]}
    assert_equal false, have.include?(undesired), ([
        'Found:', have.map{|e| e.uniq.inspect},
        'Undesired:', ([filter,kind].map{|e| e.inspect}.join ', '),
        ].join "\n")
  end

  def assert_not_logged_in
    assert_blank session[:logged_in]
  end

  def filter
    @controller.send @filter
  end

  def filter_chain
    @controller._process_action_callbacks
  end

  def get_password
    if @_password.blank?
      f=App.webmaster.join('password.txt').open 'r'
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

  def self.test_routing_tag(use_root=false)
    test "routing with and without tag" do
      root=Pathname.new '/'
      c=root.join @controller_name
      h={:controller => @controller_name, :action => @action.to_s}
      tag='some-tag'
      unless use_root
        assert_routing c.to_s, h
      else
        assert_routing root.to_s, h
# Should raise exception on controller name-only route:
        assert_raise(ActionController::RoutingError){assert_routing c.to_s, h}
      end
# With a tag, should work:
      assert_routing (c.join tag).to_s, (h.merge :tag => tag)
    end
  end

end
