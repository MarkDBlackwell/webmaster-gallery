require 'test_helper'

class EditSessionsControllerTest < SharedSessionsControllerTest
# %%co%%ses%%ed

  tests SessionsController

# -> Webmaster reviews filesystem changes.

  test "routing..." do # GET
    assert_routing({:path => '/session/edit', :method => :get}, :controller =>
        :sessions.to_s, :action => @action.to_s)
  end

  test_happy_path_response

  test "happy path should..." do
    happy_path
# Render the right template:
    assert_template :single
# Flash a message for the next step:
    assert_equal 'Ready to click the button for database problems?', flash.now[
        :notice]
# Assign approval and review groups...:
    fa=FileAnalysis.new
    %w[approval_group review_groups].each do |e|
      fe,ae=(fa.send e),(assigns e)
      assert_present ae, '@'+e
# Which have the right...:
      x=extend_with_nils=[fe.length, ae.length].max
      pairs=(!fe.kind_of? Array) ? [[fe,ae]] : (0...x).map{|i| [fe.at(i),ae.at(
          i)]}
# Message and list:
      pairs.each {|f,a| assert_equal [a.message, a.list],
                                     [f.message, f.list]}
    end
# And...:
# Assign erroneous lists...:
    ee=assigns :erroneous
    assert_present ee, '@erroneous'
# Which have the right...:
    s=Struct.new :list, :message
    places = %w[ tag\ file  picture\ directory ]
    models = %w[ FileTag    DirectoryPicture   ]
    erroneous=models.zip(places).map{|m,p| s.new m.constantize.all.select{|e|
        e.invalid?}, "#{p.capitalize} problems:"}
# Message and list:
    [:list,:message].each{|e| assert_equal erroneous.map(&e), (ee.map &e)}
  end
    
  test "when approval is needed, should..." do
    mock_file_analysis [true,false]
    pretend_logged_in
    get @action
# Not flash:
    assert_flash_blank
  end

  test "when files are invalid, should..." do
    mock_file_analysis [false,true]
    pretend_logged_in
    get @action
# Not flash:
    assert_flash_blank
  end

#-------------

  def setup
    @action=:edit
  end

  private

  def happy_path
    mock_file_analysis
    pretend_logged_in
    get @action
  end

end
