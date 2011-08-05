require 'test_helper'

class PictureTest < SharedModelTest
# %%mo%%pic

# TODO: try using Rails API's assert_field_type, if I switch to using integer attributes.

  test "..." do
    automatic = %w[ cre  upd ].map{|e| e+'ated_at'}
    optional  = %w[ description                         ]
    static    = %w[              filename  id  sequence ]
    text      = %w[ description  filename  title        ]
    numeric=(r=@record).attributes.keys-automatic-text
# Should include validations for...:
# Numericality:
    assert_validates_numericality_of numeric, :only_integer => true,
        :allow_nil => false
# Uniqueness:
    multiple = %w[ weight  year ]
    assert_validates_uniqueness_of (numeric+static).uniq-multiple
    assert_validates_uniqueness_of text-optional-static, :allow_blank => true
# Presence:
    assert_validates_presence_of text-optional
# Length:
    assert_validates_length_of :year, :is => 4
# And...:
# The right number of records should be obtained using methods...:
# Find all:
    a=@model.all
    assert_equal 2, a.length
# Find database problems:
    a.each{|e| e.weight='a'; e.save :validate => false}
    assert_equal 2, @model.find_database_problems.length
# And...:
# Associations should...:
# Have the right number of tags:
    id=(r=@record).id
    assert_equal 2, r.tags.length
# When tags are deleted, should...:
# Adjust collections:
    assert_difference('r.tags(reload=true).length',-1){tags(:one).destroy}
# When deleted, should:
# Keep associated tags:
    assert_no_difference('Tag.count'){r.destroy}
# Delete associated picture-tag joins (tests :dependent => :destroy):
##    assert_blank PictureTagJoin.find :two_one 
    assert_blank PictureTagJoin.where ['picture_id IN (?)', id]
# And...:
# Callbacks should...:
# Run before validating or saving:
    %w[validation save].each{|e| assert_before_callback :clean_fields, e}
  end

#-------------
  private

  def assert_before_callback(m,e)
    assert_callback m, e, (after=false)
  end

  def assert_callback(method,event,after)
    (r=@record).expects method
    r.run_callbacks(event){after}
  end

  def setup
    @model=Picture
    @record=pictures :two
  end

end
