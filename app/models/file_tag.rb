class FileTag
  include ActiveModel::Validations

  attr_accessor :name

  validates_each :name do |record, attr, value|
    record.errors.add attr, 'contains /' if value.include? ?/
  end

  class FindError < Exception
  end

  @records=[]
  @bad_names=[]

  def self.find (*args)
    raise FindError unless args.include? :all
    @records
  end

  def self.find_bad_names
    @bad_names
  end

  def self.read
    f=MyFile.my_new(  # MyFile.new didn't work.
        (App.webmaster.join 'tags.txt'), 'r')
    @records=(f.readlines "\n").map{|e| (r=FileTag.new).name=e.chomp "\n"; r}
    f.close
    @bad_names=[]
  end

end
