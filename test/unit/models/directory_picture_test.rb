require 'test_helper'

class DirectoryPictureTest < ActiveSupport::TestCase
# %%mo%%dir

  test "should..." do
# Use the right directory:
    assert_equal (App.root.join *%w[public images gallery]),
        (@model.send :gallery_directory)
  end

  test "mocking with directory, basic..." do
    mock_gallery_directory 'basic'
    @model.read
# Some files should have bad names:
    bad=@model.find_bad_names
    assert_equal %w[ -t.a  -t.ab  .a  .ab ].sort, bad
# All other file names should be good:
    good=@model.send :good_files
    assert_equal 14, good.length
# The right files should be unpaired:
    unpaired=@model.find_unpaired_names
    assert_equal %w[ unpaired-abc-t.jpg  unpaired-abcd-t  
                     unpaired-abc        unpaired-abcd.jpg].sort, unpaired
# The right pairs should be found:
    all=@model.find :all
    assert_equal %w[ a  a.bc  ab  ab.c  ab.cd ].sort, all.map(&:filename).sort
    assert_equal (good.length-unpaired.length)/2, all.length
# Find methods shouldn't re-read the directory:
    @model.expects(:read).never
    @model.find :all
    @model.find_bad_names
    @model.find_unpaired_names
  end

  test "when names have various extensions..." do
    thumbnail_indicator=[?-,?t]
    good=Square.new((0..4).to_a).map do |a|
      name,x=a.map{|i| Array.new(i).map{@good_c.choice}}
      x.map!{|e| e!=@dot ? e : @replace}
      (name.pop; name.push @replace) if name.last==@dot
      name[-2*t.length,t.length]=t if (t=thumbnail_indicator)*2==(name.last
            2*t.length)
      (x.present? ? [name+[@dot]+x] : [name+[@dot], name]).map &:to_s
    end.flatten
    assert_present good
# Should all be good:
# Finding good & bad names should find all & none:
    check_counts good, good.length, 0
  end

  test "when some names embed a single bad character..." do
    n=(0..4).to_a
# Consider directory separator (?/), null (?\0) & pad (?\377) as bad embedded
# characters:
    all_byte_characters = (0...2**8).to_a
    good,bad=[@good_c, all_byte_characters-@good_c].map{|a| a.map do |c|
      name=Array.new(n.choice).map{@good_c.choice}
      name.insert Range.new(0,name.length).to_a.choice, c
      name[0]=@replace if (name.rindex @dot)==0
      name.map(&:chr).to_s
    end }
    [good, bad].each{|a| assert_present a}
# When all good or all bad...:
# Finding good & bad names should find all or none:
    check_counts good, good.length, 0
    check_counts bad,  0,           bad.length
  end

#-------------
  private

  def check_counts(names,good,bad)
      @model.expects(:gallery_directory_entries).returns names
      @model.expects(:gallery_directory        ).returns @tests
      pi=Pathname.any_instance
      pi.expects(:file?).times(good).returns true
      pi.expects(:mtime).times(good).returns Time.now
      @model.read
      assert_equal good, @model.send(:good_files).length
      assert_equal bad,  @model.find_bad_names   .length
  end

  def make_reproducible_tests_involving_array_choice
    Kernel.srand 0
  end

  def mock_gallery_directory(s)
    @model.expects(:gallery_directory).at_least_once.returns @tests.join s
  end

  def setup
    make_reproducible_tests_involving_array_choice
    @model=DirectoryPicture
    @tests=App.root.join *%w[test fixtures files directory_pictures gallery]
    @good_c=[?A..?Z, ?a..?z, ?0..?9, [?-, ?.] ].map(&:to_a).flatten
    @dot,@replace=?.,?a
  end

end
