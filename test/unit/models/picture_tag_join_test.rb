require 'test_helper'

class PictureTagJoinTest < SharedModelTest
# %%mo%%pic %%mo%%tag

  test "..." do
    all=@model.first.attributes.keys
    automatic = %w[ cre upd ].map{|e| e+'ated_at'}
    numeric=all-automatic
# Should include validations for...:
# Numericality:
    assert_validates_numericality_of numeric, :only_integer => true,
        :allow_nil => false
# Uniqueness:
    am=(associated = %w[picture tag]).map(&:capitalize).map &:constantize
    f=foreign=associated.map{|e| e+'_id'}
    assert_validates_uniqueness_of numeric-f
    f.zip(f.reverse).each{|e,r| assert_validates_uniqueness_of e, :scope =>
        r.to_sym}
# Presence:
    assert_validates_presence_of all
# And...:
# The right number of records should be obtained using methods...:
# Find all:
    pl,tl,ml=(am+[@model]).map{|e| e.count}
    tl-=1 if Tag.where(deletion_test_tag={:name=>'three-name'}).exists?
    assert_equal pl+tl, ml
# And...:
## TODO: write alert-me when this works: picturetagjoins :two_two
##    r=@model.find :two_two
    pi,ti=associated.map{|e| send(e+'s',:two).id}
    s=foreign.map{|e| e+' in (?)'}.join ' AND '
    c=@model.where([s,pi,ti]).all
    r=c.first
# The right picture and tag should:
# Be associated:
    assert_equal 1, c.length
    [pi,ti].zip(foreign).each{|i,a| assert_equal i, r[a]}
# Stay when the record is deleted:
    a=[0,10].zip am
    assert_no_difference('a.map{|i,m| i+m.count}.sum'){r.destroy}
  end

#-------------

  def setup
    @model=PictureTagJoin
  end

end
