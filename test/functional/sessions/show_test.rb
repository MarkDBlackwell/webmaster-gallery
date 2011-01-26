require 'test_helper'

class ShowSessionsControllerTest < SharedSessionsControllerTest
# %%co%%ses%%sh

# -> Webmaster reviews database problems.

#-------------
# General tests:

  test "routing" do # GET
    assert_routing({:path => '/session', :method => :get}, :controller =>
        :sessions.to_s, :action => @action.to_s)
  end

  test_happy_path_response

  test "happy path should..." do
    happy_path
# Render the right template:
    assert_template :single
# Assign a single review group...:
    s='Review group'
    r=assigns :review_groups
    assert_present r, s
    assert_kind_of Array, r, s
    assert_equal 1, r.length, s
# Whose...:
# Message should be:
    assert_equal 'Pictures with database problems:', r.first.message, s
# List should be:
    assert_equal @problem_pictures, r.first.list, s
# Assign a single approval group...:
    s='Approval group'
    a=assigns :approval_group
    assert_present a, s
# Whose...:
# Message should be:
    assert_equal 'refresh database problems', a.message, s
# List should be empty:
    assert_equal '', a.list, s
# TODO: move erroneous to a model & test that model?
# And...:
# Assign erroneous lists...:
    ee=assigns :erroneous
    assert_present ee, '@erroneous'
# Which have the right...:
    s=Struct.new :list, :message
    places = %w[ database ]
    models = %w[ Picture   ]
    erroneous=models.zip(places).map{|m,p| s.new m.constantize.find(:all).
        select{|e| e.invalid?}, "#{p.capitalize} problems:"}
# Message and list:
    [:list,:message].each{|e| assert_equal erroneous.map(&e), (ee.map &e)}
  end

  test "if file tags or directory pictures approval needed, should..." do
    mock_approval_needed
    get @action
# Redirect to edit:
    assert_redirected_to :action => :edit
  end

  test "when approval is needed, should..." do
    mock_file_analysis [true,false]
    get @action
# Not flash:
    assert_flash_blank
# Redirect to edit:
    assert_redirected_to :action => :edit
  end

  test "when files are invalid, should..." do
    mock_file_analysis [false,true]
    get @action
# Not flash:
    assert_flash_blank
# Redirect to edit:
    assert_redirected_to :action => :edit
  end

#-------------
  private

  def happy_path
    mock_approval_needed false
    Picture.expects(:find_database_problems).returns(@problem_pictures=
        %w[aa bb])
    get @action
  end

  def setup
    @action=:show
    pretend_logged_in
  end

end
