class FileTag
  include ActiveModel::Validations

  attr_accessor :name

  validates_each :name do |record, attr, value|
    record.errors.add attr, 'contains /' if value.include? ?/
  end

  def self.find (*args)
    raise FindError unless args.include? :all
    f=MyFile.my_new(  # MyFile.new didn't work.
        Gallery::Application.config.webmaster.join('tags.txt'), 'r')
    collection=f.readlines("\n").collect {|e|
        (tag=FileTag.new).name=e.chomp "\n"; tag}
    f.close
    collection
  end

  class FindError < Exception
  end

end
