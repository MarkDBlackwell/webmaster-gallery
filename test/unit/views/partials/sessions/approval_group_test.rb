require 'test_helper'

class ApprovalGroupSessionsPartialTest < SharedPartialTest

  test "happy path should render..." do
# The right partial, once:
    assert_partial
# A single...:
# Approval div:
    assert_select @da, 1, @da
# Submit button:
    assert_select @ts, 1, @b
# Form...:
    assert_select @da.child(@f), 1, @f
    assert_select @f, 1, @f do
# Which is an approval form...:
      assert_select @f.attribute(@m,'post'), 1, @f
      assert_select @f.attribute('action', '/session'), 1, @f
# Which should...:
# Indicate the http method, 'put':
      assert_select @f.child(@d, @th.attribute('name', '_'+@m)), 1, @m do
        assert_select @i.attribute(@v, 'put'), 1, @m
      end
# Include a submit button...:
      assert_select @f.child(@ts), 1, @b do
# On which should be the appropriate text:
        assert_select @vq, @group.message
      end
# Include a hidden input...:
      assert_select @f.child(@th), 1, @a do
        %w[name id].each{|e| assert_select @i.attribute(e, @a+'_group'), 1, @a}
# Containing the appropriate approval group:
        assert_select @vq, @group.list
      end
    end
  end

#-------------
  private

  def setup
    @use_controller=:admin_pictures
    @group=Struct.new(:list,:message).new 'some-list', 'some-message'
    render_partial 'sessions/approval_group', :approval_group => @group
    @a, @b, @d, @f, @i, @m, @v = %w[
        approval  button  div  form  input  method  value].map{|e|
        CssString.new e}
    @th, @ts = %w[hidden  submit].map{|e| @i.attribute 'type', e}
    @vq=@i.attribute @v, '?'
    @da=@d.css_class 'approve'
  end

end
