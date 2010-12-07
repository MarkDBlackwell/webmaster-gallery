class DirectoryPicture
  include ActiveModel::Validations

  attr_accessor :filename

  validates_each :filename do |record, attr, value|
    record.errors.add attr, 'contains /' if value.include? ?/
  end

# Working_on

  def self.find (*args)
    raise FindError unless args.include? :all
    collection=[]
  end

  def self.find_unpaired
    filenames=[]
  end

  class FindError < Exception
  end

end
