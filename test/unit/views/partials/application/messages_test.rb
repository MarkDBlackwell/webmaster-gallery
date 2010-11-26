require 'test_helper'

class MessagesApplicationPartialTest < SharedViewTest

  test "should render" do
    assert_template :partial => 'application/_messages', :count => 1
  end

  test "should render pretty html source" do
    check_pretty_html_source 'Messages', %w[messages notice notice\ error]
  end

  test "should include one messages div" do
    assert_select 'div.messages', 1
  end

#-------------
  private

  def setup
    [:error,:notice].each {|e| flash.now[e]="some #{e}" }
    render :partial => 'application/messages'
  end

end
