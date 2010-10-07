class FilePassword < ActiveRecord::Base
  establish_connection :adapter => :nulldb

  def self.find (*args)
    raise FindError unless args.include? :all
    collection = super
    f = MyFile.my_new( # MyFile.new didn't work.
      "#{Rails.root}"\
      '/../gallery-webmaster/password.txt', 'r')
    t = FilePassword.new
    t[:password] = f.readlines.first.chomp
    f.close
    collection << t
    collection
  end

  class FindError < Exception
  end

end

class MyFile
  def self.my_new(*args)
    File.new(*args)
  end
end
