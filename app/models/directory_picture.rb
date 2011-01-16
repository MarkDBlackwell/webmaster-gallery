class DirectoryPicture
  include ActiveModel::Validations

  attr_accessor :filename

  validates_each :filename do |record, attr, value|
    record.errors.add attr, 'contains /' if value.include? ?/
  end

  class FindError < Exception
  end

  @records=[]
  @bad_names=[]
  @unpaired_names=[]

  def self.find(*args)
    raise FindError unless args.include? :all
    @records
  end

  def self.find_bad_names
    @bad_names
  end

  def self.find_unpaired_names
    @unpaired_names
  end

  def self.read
    g,@bad_names=self.get_files
    u=self.extract_unpaired_names g
    @records=g.reject{|e| e.is_thumbnail || (u.include? e.filename)}
    @good_files,@unpaired_names=g,u
  end

#-------------
  private

  def self.gallery_directory
    App.root.join(*%w[public images gallery]).realpath
  end

  def self.gallery_directory_entries
    self.gallery_directory.entries.map &:to_s
  end

  def self.get_files
    file_struct=Struct.new :time, :filename, :is_thumbnail
    allowed_single_characters=Regexp.escape '-.'
    forbidden_ascii=Regexp.new "[^A-Za-z0-9#{allowed_single_characters}]"
    bad_names=[]
    directory=self.gallery_directory
    good_files=self.gallery_directory_entries.map do |entry|
      has_error=(s=entry.gsub! forbidden_ascii, '?').present?
      (bad_names << s; next) if has_error
      e=directory.join entry
      begin
        next unless e.file?
        mtime=e.mtime
      rescue ArgumentError
        (bad_names << '-?-'; next)
      end
      bs=(b=e.basename).to_s
      x=b.extname
      main=bs.chomp x
      has_error=(main.ends_with? '-t-t') ||
          '-t'==main || 
          x.blank? && ?.==main[0]
      (bad_names << bs; next) if has_error
      file_struct.new mtime, bs, (main.ends_with? '-t')
    end.compact.sort{|b,a| a.filename<=>b.filename}
    [good_files, bad_names.sort]
  end

  def self.good_files # Keep for test.
    @good_files
  end

  def self.get_names(files)
    files.map(&:filename).sort
  end

  def self.extract_unpaired_names(files)
    th='-t' # Thumbnail flag in file names before the extension.
    a=self.get_names files
    self.get_names( files.reject do |e|
      x=Pathname.new(s=e.filename).extname
      main=s.chomp x
      a.include? e.is_thumbnail ? main.chomp(th)+x : main+th+x
    end )
  end

end
