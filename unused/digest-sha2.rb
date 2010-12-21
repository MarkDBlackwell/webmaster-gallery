# Author: Mark D. Blackwell
# Date written: October 7, 2010.
# Date last updated: December 21, 2010.

# Ref. 'encrypting data with ruby and OpenSSL' at: 
# http://snippets.dzone.com/posts/show/576

require 'English'
require 'fileutils'
require 'digest/sha2'

clear_text_string='apple'
name=%w[/home mark rails-apps gallery test fixtures files file_password 
  encrypted-password.txt].join '/'
f=File.new(name,'w')
s=Digest::SHA2.digest(clear_text_string)
puts '$\ not nil' unless $OUTPUT_RECORD_SEPARATOR.nil?
f.print(s)
f.close
puts "#{File.size(name)} bytes written to #{name}."
