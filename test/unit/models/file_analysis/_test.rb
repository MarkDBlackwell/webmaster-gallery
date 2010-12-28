require 'test_helper'

class FileAnalysisTest < ActiveSupport::TestCase

# working on review_groups
# working on sessions_show

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
  end

  test "if nothing to approve..." do
    mock_directory_pictures
    mock_file_tags
    happy_path
# Approval group list and message should be appropriate:
    check_approval_group [], 'refresh'
  end

  test "should review file tag bad names first" do
    mock_file_tag_bad_names(u= %w[a b])
    happy_path
    check_approval_group [], 'refresh'
    check_review_groups 2, u
  end

  test "should review directory picture bad names second" do
    mock_directory_picture_bad_names(u= %w[a b])
    happy_path
    check_approval_group [], 'refresh'
    check_review_groups 3, u
  end

  test "should review unpaired directory pictures third" do
    mock_unpaired(u= %w[a b])
    happy_path
    check_approval_group [], 'refresh'
    check_review_groups 4, u
  end

  %w[tag picture].each_with_index do |model,i|
    %w[add delet].each do |operation|
      1.upto 2 do |count|
        test "should review #{count} #{operation}ed_#{model}s" do
          expected,change=construct_changes model, operation, count
          mock_expected model, expected
          happy_path
          check_approval_group change, "approve #{operation}ing #{model}s"
# TODO: Why this formula? Refactor.
          check_review_groups 4*i+3, change,
              "#{model.capitalize}s to be #{operation}ed:"
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
    assert_equal g.message, message, "#{s} message"
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

end
