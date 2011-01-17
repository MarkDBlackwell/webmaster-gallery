class FileTag
  include ActiveModel::Validations

  attr_accessor :name

  validates_each :name do |record, attr, value|
    characters,names=[?/, ??], '-?-'
    messages=['contains a directory separator (/)',
              'contains a bad character', 
              'is bad',
        ]
    (characters.map{|e| value.include? e} +
    [names    ].map{|e| e==value        }).zip(messages).
        each{|b,m| record.errors.add attr, m if b}
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
    @records.each{|e| e.valid?}
  end

end
