class DirectoryPicture
# %%mo%%dir

  include ActiveModel::Validations

  class << self; private # Keep for test.
    attr_reader :good_files
  end

  attr_accessor :filename
# TODO: Restrict access to the sequence.
  attr_accessor :sequence

  validates_each :filename do |record, attr, value|
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
  @unpaired_names=[]

  def self.all
    @records
  end

  def self.find(*args)
    raise FindError unless args.include? :all
    self.all
  end

  def self.find_bad_names
    @bad_names
  end

  def self.find_unpaired_names
    @unpaired_names
  end

  def self.read
    self.get_files
    u=@unpaired_names=self.extract_unpaired_names
    paired=@good_files.reject{|e| e.is_thumbnail || (u.include? e.filename)}.
         sort{|a,b| a.time <=> b.time}
    @records=(0...paired.length).zip(paired).map do |i,e|
      r=self.new
      r.filename=e.filename
      r.sequence=i
      r.valid?
      r
    end
  end

#-------------
  private

  def self.extract_unpaired_names
    th='-t' # Thumbnail flag in file names before the extension.
    a=@good_files.map(&:filename).sort
    @good_files.reject do |e|
      x=Pathname.new(s=e.filename).extname
      main=s.chomp x
      a.include? e.is_thumbnail ? main.chomp(th)+x : main+th+x
    end.map(&:filename).sort
  end

  def self.gallery_directory # Keep for test.
    App.root.join(*%w[public images gallery]).realpath
  end

  def self.gallery_directory_entries # Keep for test.
    self.gallery_directory.entries.map &:to_s
  end

  def self.get_files
    file_struct=Struct.new :time, :filename, :is_thumbnail
    allowed_single_characters=Regexp.escape '-._'
    forbidden_ascii=Regexp.new "[^A-Za-z0-9#{allowed_single_characters}]"
    @bad_names=[]
    directory=self.gallery_directory
    @good_files=self.gallery_directory_entries.map do |entry|
      has_error=(s=entry.gsub! forbidden_ascii, '?').present?
      (@bad_names << s; next) if has_error
      e=directory.join entry
      begin
        next unless e.file?
        time=e.mtime
      rescue ArgumentError
        (@bad_names << '-?-'; next)
      end
      bs=(b=e.basename).to_s
      x=b.extname
      main=bs.chomp x
      has_error=(main.ends_with? '-t-t') ||
          '-t'==main || 
          x.blank? && ?.==main[0]
      (@bad_names << bs; next) if has_error
      file_struct.new time, bs, (main.ends_with? '-t')
    end.compact.sort{|b,a| a.filename<=>b.filename}
    @bad_names.sort!
    nil
  end

end
