require 'test_helper'

class CleanFieldsCallbackPictureTest < ActiveSupport::TestCase
# %%mo%%pic

  test "..." do
    automatic = %w[ cre  upd ].map{|e| e+'ated_at'}
    static    = %w[              filename  id  sequence ]
    text      = %w[ description  filename  title        ]
# User input fields...:
    correct = %w[ some-value  26      ]
    pad     =   [ '  ',       '  +  ' ]
    ((r=pictures :two).attributes.keys-automatic-static).partition{|e| text.
        include? e}.zip(pad,correct).each do |fields,p,c|
# With leading or trailing blanks (or plus signs)...:
      fields.each{|e| r[e]=p+c+p}
      r.send :clean_fields
# Should be stripped:
      fields.each{|e| assert_equal c, r[e], e}
    end
  end

end
