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
    assert_equal 6, DirectoryPicture.find(:all).length
# Find unpaired names should find all:
    assert_equal 6, DirectoryPicture.find_unpaired_names.length
  end

  test "names embedded with a single bad character..." do
    is_thumbnail=false
    time=Time.now
    web_picture_extensions = %w[ .gif .giff .jpeg .jpg .png ]
    n=(0..3).to_a
    two=Array.new 2
# Use directory separator (?/), null (?\0) & pad (?\377) as bad embedded
# characters:
    good_c = [?A..?Z, ?a..?z, ?0..?9, [?-, ?.] ].map{|e| e.to_a}.flatten
    all_byte_characters = (0...2**8).to_a
    bad_c = all_byte_characters - good_c
    good,bad=[good_c,bad_c].map{|a| a.map do |c|
      before,after=two.map{Array.new(n.choice).map{good_c.choice}}
      (before + [c] + after).flatten.map{|e| e.chr}.to_s +
          web_picture_extensions.choice
    end }
    [good, bad].each{|a| assert a.length > 0}
    dp=DirectoryPicture
    pi=Pathname.any_instance
# When all good or all bad...:
# Finding good & bad names should find all or none:
    [   [good,  good.length, 0         ],
        [bad,   0,           bad.length]   ].each do
        |names, good_length, bad_length|
      called=2
      dp.expects(:gallery_directory        ).times(called).returns @tests
      dp.expects(:gallery_directory_entries).times(called).returns names
      good_called=good_length*called
      pi.expects(:mtime).times(good_called).returns Time.now
      pi.expects(:file?).times(good_called).returns true
      assert_equal good_length, dp.find(:all)    .length
      assert_equal bad_length,  dp.find_bad_names.length
    end
  end

#-------------
  private

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
