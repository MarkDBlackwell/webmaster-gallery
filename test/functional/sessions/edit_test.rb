require 'test_helper'

class EditSessionsControllerTest < SharedSessionsControllerTest

# -> Webmaster reviews filesystem changes.

  test_happy_path_response

  test "routing" do
    assert_routing({:path => '/session/edit', :method => :get}, :controller =>
        :sessions.to_s, :action => :edit.to_s)
  end

  test "happy path (if logged in)..." do
    happy_path
# Should render edit:
    assert_template :edit
# Should assign groups:
    %w[approval_group review_groups].each do |e|
      assert_present assigns(e), "Should assign @#{e}"
    end
# Review groups should include...:
    assigns(:review_groups).each do |e|
      assert_present e.list, 'list'
      assert_present e.message, 'message'
    end
  end

  test "should review added tags" do
    added=['three-name']
    expected=Tag.find(:all).map(&:name).take(1).concat added
    FileTag.expects(:find).returns expected.collect {|e|
        (p=FileTag.new).expects(:name).returns e; p }
    happy_path
# Review groups...:
    s='Review group'
    review=assigns(:review_groups)
# Count should be:
    assert_equal 2, review.length, "#{s} length"
# Messages should be:
    m=['Tags in file:','Existing pictures:', 'Pictures in directory:']
    m=m.take(1).push 'Tags to be added:'
    review.each_with_index do |e,i|
      assert_equal e.message, m.at(i), "#{s} #{i}"
    end
# Approval group should be:
    assert_equal added, assigns(:approval_group), 'Approval'
  end

  test "should review deleted tags" do
    expected=Tag.find(:all).map(&:name)
    deleted=expected.pop(1)
    FileTag.expects(:find).returns expected.collect {|e|
        (p=FileTag.new).expects(:name).returns e; p }
    happy_path
# Review group...:
    s='Review group'
    review=assigns(:review_groups)
# Count should be:
    assert_equal 2, review.length, "#{s} length"
# Messages should be:
    m=['Tags in file:','Existing pictures:', 'Pictures in directory:']
    m=m.take(1).push 'Tags to be deleted:'
    review.each_with_index do |e,i|
      assert_equal e.message, m.at(i), "#{s} #{i}"
    end
# Approval group should be:
    assert_equal deleted, assigns(:approval_group), 'Approval'
  end

  test "should review added pictures" do
    expected=Tag.find(:all).map(&:name)
    FileTag.expects(:find).returns expected.collect {|e|
        (p=FileTag.new).expects(:name).returns e; p }
    added=['three.png']
    expected=Picture.find(:all).map(&:filename).take(1).concat added
    DirectoryPicture.expects(:find).returns expected.collect {|e|
        (p=DirectoryPicture.new).expects(:filename).returns e; p }
    happy_path
# Review group...:
    s='Review group'
    review=assigns(:review_groups)
# Count should be:
    assert_equal 4, review.length, "#{s} length"
# Messages should be:
    m=['Tags in file:','Existing pictures:', 'Pictures in directory:']
    m=m.take(3).push 'Pictures to be added:'
    review.each_with_index do |e,i|
      assert_equal e.message, m.at(i), "#{s} #{i}"
    end
# Approval group should be:
    assert_equal added, assigns(:approval_group), 'Approval'
  end

  test "should review deleted pictures" do
    expected=Tag.find(:all).map(&:name)
    FileTag.expects(:find).returns expected.collect {|e|
        (p=FileTag.new).expects(:name).returns e; p }
    expected=Picture.find(:all).map(&:filename)
    deleted=expected.pop(1)
    DirectoryPicture.expects(:find).returns expected.collect {|e|
        (p=DirectoryPicture.new).expects(:filename).returns e; p }
    happy_path
# Review group...:
    s='Review group'
    review=assigns(:review_groups)
# Count should be:
    assert_equal 4, review.length, "#{s} length"
# Messages should be:
    m=['Tags in file:','Existing pictures:', 'Pictures in directory:']
    m=m.take(3).push 'Pictures to be deleted:'
    review.each_with_index do |e,i|
      assert_equal e.message, m.at(i), "#{s} #{i}"
    end
# Approval group should be:
    assert_equal deleted, assigns(:approval_group), 'Approval'
  end

#-------------
  private

  def happy_path
    pretend_logged_in
    get :edit
  end

end
