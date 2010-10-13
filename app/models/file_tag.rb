class FileTag
  include ActiveModel::Validations

  validates_each :name do |record, attr, value|
    record.errors.add attr, 'contains /' if value.include? ?/
  end

  attr_accessor :name

  def self.find (*args)
    raise FindError unless args.include? :all
    f = MyFile.my_new( # MyFile.new didn't work.
      "#{Rails.root}"\
      '/../gallery-webmaster/tags.txt', 'r')
    result = f.readlines.collect do |e|
      ft = FileTag.new
      ft.name = e.chomp
      ft
    end
    f.close
    result
  end

  class FindError < Exception
  end

end

class MyFile
  def self.my_new(*args)
    File.new(*args)
  end
end
