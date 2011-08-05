require 'test_helper'

class FileAnalysisTest < ActiveSupport::TestCase
# %%mo%%fan

  test "happy path..." do
    happy_path
# Review-message texts should be:
    assert_equal review_messages, @fa.review_messages
# Groups should include a message:
    (@fa.review_groups.clone<<@fa.approval_group).each_with_index do |e,i|
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
# TODO: FileAnalysisTest sometimes fails; don't know why; seems related to static asset digits (see test/unit/views/_shared.rb).
##    check_changes true, ['tag', 'add', 0]
    check_changes true, ['tag', 'add', 2]
  end

  test "if nothing to approve..." do
    mock_directory_pictures
    mock_file_tags
    happy_path
# Approval group list and message should be appropriate:
    check_approval_group [], 'refresh'
# TODO: FileAnalysisTest sometimes fails; don't know why; seems related to static asset digits (see test/unit/views/_shared.rb).
##    check_changes true
    check_changes false
  end

  (0..2).zip([ %w[ file      tag     bad ],
               %w[ directory picture bad ],
               %w[ unpaired              ]].
      map{|e| e.push 'names'}) do |i,e|
    test "should review #{e.join ' '} #{%w[first second third].at i}" do
      bad = %w[a b]
      send e.unshift('mock').join('_'), bad
          #-> mock_file_tag_bad_names
          #-> mock_directory_picture_bad_names
          #-> mock_unpaired_names
      happy_path
      check_approval_group [], 'refresh'
      check_review_groups [1,2,3].at(i), bad
      check_changes true
    end
  end

  %w[tag picture].each_with_index do |model,i|
    %w[add delet].each do |operation|
      1.upto 2 do |how_many|
        test "should review #{how_many} #{operation}ed_#{model}s" do
          expected,change=construct_changes_strings model, operation, how_many
          mock_expected model, expected
          happy_path
          check_approval_group change, "approve #{operation}ing #{model}s"
          check_review_groups [2,4].at(i), change,
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
    assert_equal an, @fa.approval_needed?, @fa.inspect + 'approval_needed?'
    return unless difference
# Make_changes should change the database:
    model,operation,how_many=*difference
    other=(a= %w[tag picture]).at a.reverse.index model
    model,other=[model,other].map(&:capitalize).map &:constantize
    n=[1,-1].at( %w[add delet].index operation) * how_many
    expected=[model.count + n, other.count]
    @fa.make_changes
    assert_equal expected, [model.count, other.count], @fa.inspect
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
    b,d,i,p = %w[ bad directory in picture]
    ns,ps = ['name', p].map{|e| e.pluralize}
    [
          [          b, 'tag', ns, i, 'file', ],
          [          b,     p, ns, i,      d, ],
          [ 'unpaired',        ps, i,      d, ],
        ].map{|e| e.join(' ').capitalize.concat ':'}
  end

  def setup
    DirectoryPicture.expects(:find_bad_names).at_least(0).returns []
    %w[FileTag DirectoryPicture].each{|e| e.constantize.read}
  end

end
