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
# Invoke method, 'render_show':
    assert_flag :edit_allowed
  end

  test "if record is invalid, should..." do
    Picture.any_instance.expects(:valid?).at_least_once.returns false
    request_changes
# Make changes anyway:
    check_changes
# Redirect to edit:
    assert_redirected_to :action => :edit
  end

#-------------
  private

  def check_changes
    c=@changes
    et=expected_tags=(c.delete 'tags').split.sort & (Tag.all.map &:name)
    p=Picture.find @record.id
# Should make changes:
    c.each_pair{|k,v| assert_equal v, p[k], k}
# Should change tags:
    assert_equal expected_tags, p.tags.map(&:name).sort
# Should update:
    u='updated_at'
    assert @record[u]!=p[u], u
# Shouldn't change the attributes created_at, filename, id, or sequence:
    (@static+@automatic-[u]).each{|e| assert_equal @record[e], p[e], e}
# Flash a notice:
    assert_blank flash[:error].to_s+flash.now[:error].to_s
    s='Tag nonexistent: '+@bad_tag_name
    assert_equal s, flash[:notice]
    assert_equal s, flash.now[:notice]
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
# Should handle all altered fields:
    k=(a=r.attributes).keys
    v=k.map{|e| (a.fetch e).succ}
# Should handle tags that are...:
    k.push 'tags'
    rt,ta=[@record.tags,Tag.all].map{|e| e.map(&:name).sort}
# Removed & added:
    assert rt.length > 1
    rt[0]='three-name'
# Bad:
    rt.push(@bad_tag_name='bad-tag-name')
    v.push(rt.join ' ')
    @changes=Hash[ *(k.zip(v).flatten 1) ]
    (@static+@automatic).each{|e| @changes.delete e}
# Should silently drop wild attribute names:
    put :update, :picture => (@changes.merge 'some-attribute' => 'a'), :id =>
        @record.id
  end

end
