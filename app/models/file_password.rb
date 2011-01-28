class FilePassword
# %%mo%%fpa

  include ActiveModel::Validations

  attr_accessor :password

  validates_each :password do |record, attr, value|
    record.errors.add attr, 'too short' if value.to_s.length < 10
  end

  class FindError < Exception
  end

  def self.all
    [self.first]
  end

  def self.find (*args)
    raise FindError unless args.include? :all
    self.all
  end

  def self.first
    f=MyFile.my_new(  # MyFile.new didn't work.
        (App.webmaster.join 'password.txt'), 'r')
    (result=FilePassword.new).password=f.readline("\n").chomp "\n"
    f.close
    result
  end

end
