#!/usr/bin/env ruby
# Author: Mark D. Blackwell
# See Ruby Enumerable#zip.

class Array
  def map_with_index
    (0...self.length).map{|i| yield self.at(i),i}
  end
end

a=%w[d e f]
p %w[a b c].map_with_index(&:*)

#=> ["", "b", "cc"]

p %w[a b c].map_with_index{|e,i| a.at(i) + e}

#=> ["da", "eb", "fc"]
