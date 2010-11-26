class SharedViewTest < ActionView::TestCase

  private

  def check_pretty_html_source(*a)
    type   = %w[  section  div            tag  other  ]
    prefix = %w[  <!--     <div\ class="  <           ]
    suffix = %w[  -->      "                          ]
    args=*a.collect {|e| e.kind_of?(Array) ? e : [e]}
# TODO: change to some array method like pad.
    args << [] until type.length==args.length
    [prefix,suffix].each {|a| a << '' until type.length==a.length }
# TODO: change to some string method like prepend.
    source="\n".concat rendered
    type.length.times do |i|
      s = "#{prefix.at(i)
          }#{Regexp.union args.at(i)
          }#{suffix.at(i)}"
      altered=source.gsub(Regexp.new("\n"+s),"\n") # From line beginnings.
      found=altered.clone.gsub!(Regexp.new(s),'')
# TODO: display first different line (use string method?).
      see_output altered if found.present?
      assert found.blank?, type.at(i)
    end
  end

end