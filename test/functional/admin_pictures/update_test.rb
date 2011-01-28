require 'test_helper'

class UpdateAdminPicturesControllerTest < SharedAdminPicturesControllerTest
# %%co%%adm%%up %%adm%%si %%mo%%pic

  test "routing" do # PUT
    assert_routing({:path => '/admin_pictures/2', :method => :put},
        :controller => :admin_pictures.to_s, :action => :update.to_s,
        :id => '2')
  end

  test_happy_path_response

  test "happy path should..." do
    happy_path
# Make changes:
    check_changes
# Not flash:
    assert_flash_blank
# Invoke method, 'render_show':
    assert_flag :editable
  end

  test "if record is invalid, should..." do
    Picture.any_instance.expects(:valid?).at_least_once.returns false
    request_changes
# Make changes anyway:
    check_changes
# Redirect to edit:
    assert_redirected_to :action => :edit
# Not flash here:
    assert_flash_blank
  end

#-------------
  private

  def check_changes
    c=@changes
    p=Picture.find @record.id
# Should make changes:
    c.each_pair{|k,v| assert_equal v, p[k], k}
# Should update:
    u='updated_at'
    assert @record[u]!=p[u], u
# Shouldn't change the attributes created_at, filename, id, or sequence:
    (@static+@automatic-[u]).each{|e| assert_equal @record[e], p[e], e}
  end

  def happy_path
    request_changes
  end

  def request_changes
    pretend_logged_in
    @static    = %w[ id  filename  sequence ]
    @automatic = %w[ cre  upd ].map{|e| e+'ated_at'}
    r=@record=(pictures :two)
    id=r.id
    k=(a=r.attributes).keys
    v=k.map{|e| (a.fetch e).succ}
    @changes=Hash[ *(k.zip(v).flatten 1) ]
    (@static+@automatic).each{|e| @changes.delete e}
# Should silently drop wild attribute names:
    put :update, :picture => (@changes.merge 'some-attribute' => 'a'), :id =>
        @record.id
  end

end
