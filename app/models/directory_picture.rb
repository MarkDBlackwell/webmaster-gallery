class DirectoryPicture
  include ActiveModel::Validations

  attr_accessor :filename

  validates_each :filename do |record, attr, value|
    record.errors.add attr, 'contains /' if value.include? ?/
  end

  def self.find (*args)
    raise FindError unless args.include? :all
    collection=[]
  end

  class FindError < Exception
  end

end
