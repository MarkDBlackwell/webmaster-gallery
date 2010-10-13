class DirectoryPicture
  include ActiveModel::Validations

  validates_each :filename do |record, attr, value|
    record.errors.add attr, 'contains /' if value.include? ?/
  end

  attr_accessor :filename

  def self.find (*args)
    raise FindError unless args.include? :all
    []
  end

  class FindError < Exception
  end

end
