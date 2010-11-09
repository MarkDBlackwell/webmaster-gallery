class FilePassword
  include ActiveModel::Validations

  attr_accessor :password

  validates_each :password do |record, attr, value|
    record.errors.add attr, 'too short' if value.to_s.length < 10
  end

  def self.find (*args)
    raise FindError unless args.include? :all
    f = MyFile.my_new( # MyFile.new didn't work.
      "#{Gallery::Application.config.webmaster}/password.txt", 'r')
    fp = FilePassword.new
    fp.password = f.readline("\n").chomp "\n"
    f.close
    [fp]
  end

  class FindError < Exception
  end

end

class MyFile
  def self.my_new(*args)
    File.new(*args)
  end
end
