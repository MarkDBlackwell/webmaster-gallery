class FilePassword
  include ActiveModel::Validations

  attr_accessor :password

  validates_each :password do |record, attr, value|
    record.errors.add attr, 'too short' if value.to_s.length < 10
  end

  def self.find (*args)
    raise FindError unless args.include? :all
    f=MyFile.my_new(  # MyFile.new didn't work.
        App.webmaster.join('password.txt'), 'r')
    (password=FilePassword.new).password=f.readline("\n").chomp "\n"
    f.close
    collection=[password]
  end

  class FindError < Exception
  end

end
