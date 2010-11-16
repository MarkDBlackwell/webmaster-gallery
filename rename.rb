require 'find'
require 'fileutils'
Find.find([Dir.pwd,'test'].join("/")) do |path|
  b=File.basename(path)
  Find.prune if FileTest.directory?(path) && ?.==b[0]
  if 'private.rb'==b
    FileUtils.cd(File.dirname(path)) do
       print "cd #{Dir.pwd}\n"
       print "git mv #{b} shared.rb\n"
    end
  end
end
