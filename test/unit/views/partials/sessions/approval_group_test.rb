require 'test_helper'

class ApprovalGroupSessionsPartialTest < SharedPartialTest

  test "happy path should render..." do
# The right partial, once:
    assert_partial

# A single approval div:
    assert_select @da, 1, @da
# A single submit button:
    assert_select @is, 1, @b
# A single form...:
    assert_select @da+'>'+@f, 1, @f
    assert_select @f, 1, @f do
# Which is an approval form...:
      assert_select @f+(attribute @m, 'post'), 1, @f
      assert_select @f+(attribute 'action', '/session'), 1, @f
# Which should include a submit button...:
      assert_select @f+'>'+@is, 1, @b do
# On which should be the appropriate text:
        assert_select @ivq, @group.message
      end
# Which should indicate the http method, 'put':
      assert_select(@f+'>div>'+@ih+(attribute 'name', '_'+@m), 1, @m) do
        assert_select @i+(attribute @v, 'put'), 1, @m
      end
# Which should include a hidden input...:
      assert_select @f+'>'+@ih, 1, @a do
        %w[name id].each{|e| assert_select @i+(attribute e, @a+'_group'), 1, @a}
# Which in turn contains the appropriate approval group:
        assert_select @ivq, @group.list
      end
    end
  end

#-------------
  private

  def setup
    @a='approval'
    @b='button'
    @da='div.approve'
    @f='form'
    @i='input'
    @m='method'
    @v='value'
    @ih, @is = %w[hidden submit].map{|e| @i+(attribute 'type', e)}
    @ivq=@i+(attribute @v, '?')
    @group=Struct.new(:list,:message).new 'some-list', 'some-message'
    render_partial 'sessions/approval_group', :approval_group => @group
  end

  def attribute(*a)
    '[' + a.shift + ('=' + a.shift if a.present?) + ']'
  end

end
