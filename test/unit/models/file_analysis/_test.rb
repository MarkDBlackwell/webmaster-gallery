require 'test_helper'

class FileAnalysisTest < ActiveSupport::TestCase

  test "happy path..." do
    happy_path
# Review-message texts should be:
    assert_equal review_messages, @fa.review_messages
# Groups should include a message:
    (@fa.review_groups.clone << @fa.approval_group).
          each_with_index do |e,i|
      assert_kind_of String, e.message, (s="message #{i}")
      assert_present e.message, s
    end
# Review groups should include a list:
    @fa.review_groups.each_with_index do |e,i|
      assert_kind_of Array, e.list, "list #{i}"
    end
# Approval group should include a list:
    assert_kind_of String, @fa.approval_group.list,
        'approval group list'
    check_changes true, ['tag', 'add', 2]
  end

  test "if nothing to approve..." do
    mock_directory_pictures
    mock_file_tags
    happy_path
# Approval group list and message should be appropriate:
    check_approval_group [], 'refresh'
    check_changes false
  end

  test "should review file tag bad names first" do
    mock_file_tag_bad_names(u= %w[a b])
    happy_path
    check_approval_group [], 'refresh'
    check_review_groups 2, u
    check_changes true
  end

  test "should review directory picture bad names second" do
    mock_directory_picture_bad_names(u= %w[a b])
    happy_path
    check_approval_group [], 'refresh'
    check_review_groups 3, u
    check_changes true
  end

  test "should review unpaired directory pictures third" do
    mock_unpaired_names(u= %w[a b])
    happy_path
    check_approval_group [], 'refresh'
    check_review_groups 4, u
    check_changes true
  end

  %w[tag picture].each_with_index do |model,i|
    %w[add delet].each do |operation|
      1.upto 2 do |how_many|
        test "should review #{how_many} #{operation}ed_#{model}s" do
          expected,change=construct_changes_strings model, operation, how_many
          mock_expected model, expected
          happy_path
          check_approval_group change, "approve #{operation}ing #{model}s"
# TODO: Why this formula? Refactor.
          check_review_groups 4*i+3, change,
              "#{model.capitalize}s to be #{operation}ed:"
          check_changes true, [model, operation, how_many]
        end
      end
    end
  end

#-------------
  private

  def check_approval_group(changed,message)
    g=@fa.approval_group
# List should be:
    s='Approval'
    assert_equal (changed.sort.join ' '), g.list, "#{s} list"
# Message should be:
    assert_equal message, g.message, "#{s} message"
  end

  def check_changes(an,difference=nil)
# Approval should be needed before changes:
    assert_equal an, @fa.approval_needed?
    return unless difference
# Make_changes should change the database:
    model,operation,how_many=*difference
    a = %w[tag picture]
    other=a.at( (1 + a.index(model)) %2)
    model,other=[model,other].map(&:capitalize).map &:constantize
    n=[1,-1].at( %w[add delet].index operation) * how_many
    expected=[model.count + n, other.count]
    @fa.make_changes
    assert_equal expected, [model.count, other.count]
  end

  def check_review_groups(count,changed,m=nil)
    messages=review_messages.take m ? count-1 : count
    messages.push m if m
    groups=@fa.review_groups
# Count should be:
    s1='Review group'
    assert_equal count, groups.length, "#{s1}s count"
# Review groups...
    groups.each_with_index do |e,i|
      s="#{s1} #{i}"
# Message should be:
      assert_equal messages.at(i), e.message, s
# Last group...
      next unless groups.length-1==i
# List should be:
      l=e.list
      f=l.first
      case
      when (f.kind_of? Picture) then l.map! &:filename
      when (f.kind_of? Tag    ) then l.map! &:name end
      assert_equal changed.sort, l, s
    end
  end

  def happy_path
    @fa=FileAnalysis.new    
  end

  def review_messages
    b,d,f,i,p,t = %w[ bad directory file in picture tag]
    ns,ps,ts = ['name', p, t].map{|e| e.pluralize}
    [
          [                 ts, i, f, ],
          [          b,  t, ns, i, f, ],
          [          b,  p, ns, i, d, ],
          [ 'unpaired',     ps, i, d, ],
          [ 'existing',     ps,       ],
          [                 ps, i, d, ],
        ].map{|e| e.join(' ').capitalize.concat ':'}
  end

  def setup
    DirectoryPicture.expects(:find_bad_names).at_least(0).returns []
  end

end
