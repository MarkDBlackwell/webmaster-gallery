require 'test_helper'

class DirectoryPictureTest < ActiveSupport::TestCase

  test "Directory Picture should..." do
# Use the right directory:
    assert_equal (App.root.join *%w[public images gallery]),
        (DirectoryPicture.send :gallery_directory)
  end

  test "basic directory..." do
    mock_gallery_directory 'basic'
# Find all should find all files:
    found_all=DirectoryPicture.find :all
    assert_equal 10, found_all.length
# Find bad names should find none:
    assert_equal 0, DirectoryPicture.find_bad_names.length
# Find unpaired names should find:
    assert_equal 4, DirectoryPicture.find_unpaired_names.length
    assert_equal %w[ abc abc-t.jpg abcd.jpg abcd-t ].sort,
        DirectoryPicture.find_unpaired_names
  end

  test "names with various extensions..." do
    thumbnail_indicator=[?-,?t]
    replace=?a
    dot=?.
    good_c = [?A..?Z, ?a..?z, ?0..?9, [?-, ?.] ].map{|e| e.to_a}.flatten
    good=Square.new((0..4).to_a).map do |a|
      name,x=a.map{|i| Array.new(i).map{good_c.choice}}
      x.map!{|e| e!=dot ? e : replace}
      (name.pop; name.push replace) if name.last==dot
      name[-2*t.length,t.length]=t if (t=thumbnail_indicator)*2==(name.last 4)
      (x.present? ? [name+[dot]+x] : [name+[dot], name]).map{|e| e.to_s}
    end.flatten
    assert_present good
# Should all be good:
# Finding good & bad names should find all & none:
    [   [good,  good.length, 0         ] ].each do
        |names, good_length, bad_length|
      called=2
      dp=DirectoryPicture
      dp.expects(:gallery_directory        ).times(called).returns @tests
      dp.expects(:gallery_directory_entries).times(called).returns names
      good_called=good_length*called
      pi=Pathname.any_instance
      pi.expects(:mtime).times(good_called).returns Time.now
      pi.expects(:file?).times(good_called).returns true
      assert_equal good_length, dp.find(:all)    .length
      assert_equal bad_length,  dp.find_bad_names.length
    end
  end

  test "names embedded with a single bad character..." do
    n=(0..4).to_a
# Use directory separator (?/), null (?\0) & pad (?\377) as bad embedded
# characters:
    good_c = [?A..?Z, ?a..?z, ?0..?9, [?-, ?.] ].map{|e| e.to_a}.flatten
    all_byte_characters = (0...2**8).to_a
    bad_c = all_byte_characters - good_c
    good,bad=[good_c,bad_c].map{|a| a.map do |c|
      name=Array.new(n.choice).map{good_c.choice}
      name.insert((0..name.length).to_a.choice,c).map{|e| e.chr}.to_s
    end }
    [good, bad].each{|a| assert_present a}
# When all good or all bad...:
# Finding good & bad names should find all or none:
    [   [good,  good.length, 0         ],
        [bad,   0,           bad.length]   ].each do
        |names, good_length, bad_length|
      called=2
      dp=DirectoryPicture
      dp.expects(:gallery_directory        ).times(called).returns @tests
      dp.expects(:gallery_directory_entries).times(called).returns names
      good_called=good_length*called
      pi=Pathname.any_instance
      pi.expects(:mtime).times(good_called).returns Time.now
      pi.expects(:file?).times(good_called).returns true
      assert_equal good_length, dp.find(:all)    .length
      assert_equal bad_length,  dp.find_bad_names.length
    end
  end

#-------------
  private

  def check_good_and_bad_names
  end

  def make_reproducible_tests_involving_array_choice
    Kernel.srand 0
  end

  def mock_gallery_directory(s)
    DirectoryPicture.expects(:gallery_directory).at_least_once.returns(@tests.
        join s)
  end

  def setup
    @tests=App.root.join *%w[test fixtures files directory_pictures gallery]
    make_reproducible_tests_involving_array_choice
  end

end
