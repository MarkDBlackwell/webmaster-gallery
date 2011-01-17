require 'test_helper'

class EditSessionsControllerTest < SharedSessionsControllerTest

# -> Webmaster reviews filesystem changes.

  test "routing..." do # GET
    assert_routing({:path => '/session/edit', :method => :get}, :controller =>
        :sessions.to_s, :action => @action.to_s)
  end

  test_happy_path_response

  test "happy path..." do
    happy_path
# Should render the right template:
    assert_template :single
# Should assign approval and review groups...:
    fa=FileAnalysis.new
    %w[approval_group review_groups].each do |e|
      fe,ae=(fa.send e),(assigns e)
      assert_present ae, "Should assign @#{e}"
# Which have the right...:
      (   (! fe.kind_of? Array) ?
          [[fe,ae]] :
          (0...[fe.length,ae.length].max).map{|i| [(fe.at i),(ae.at i)]}
# Message and list:
      ).each {|f,a| assert_equal [a.message, a.list],
                                 [f.message, f.list]}
    end
  end
    
#-------------
  private

  def happy_path
    pretend_logged_in
    get @action
  end

  def setup
    @action=:edit
  end

end
