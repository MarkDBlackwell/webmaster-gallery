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
# With leading or trailing blanks (or plus signs), should...:
      fields.each{|e| r[e]=p+c+p}
      r.send :clean_fields
# Be stripped:
      fields.each{|e| assert_equal c, r[e], e}
# With both plus and minus signs, should...:
      if p.strip.present?
        s=p+c+'-'+p
        fields.each{|e| r[e]=s}
        r.send :clean_fields
# Not strip the signs:
        fields.each{|e| assert_equal s.strip, r[e], e}
      end
    end
# Empty fields with defaults should...:
    %w[weight year].zip(['0',Time.now.year.to_s]) do |field,default|
      [nil,''].each do |e|
        r[field]=e
        r.send :clean_fields
# Be changed to default:
        assert_equal default, r[field]
      end
    end
  end

end
