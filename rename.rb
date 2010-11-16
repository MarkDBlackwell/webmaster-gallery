require 'find'
require 'fileutils'
Find.find([Dir.pwd,'test'].join("/")) do |path|
  b=File.basename(path)
  Find.prune if FileTest.directory?(path) && ?.==b[0]
  if 'test.rb'==b
    FileUtils.cd(File.dirname(path)) do
       print "cd #{Dir.pwd}\n"
       print "git mv #{b} _#{b}\n"
    end
  end
end
