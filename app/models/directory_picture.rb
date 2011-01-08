class DirectoryPicture
  include ActiveModel::Validations

  attr_accessor :filename

  validates_each :filename do |record, attr, value|
    record.errors.add attr, 'contains /' if value.include? ?/
  end

  class FindError < Exception
  end

  def self.find(*args)
    raise FindError unless args.include? :all
    files=self.get_good_files
    unpaired=self.get_unpaired_names files
    files.reject{|e| e.is_thumbnail || (unpaired.include? e.filename)}
  end

  def self.find_bad_names
    self.get_bad_names
  end

  def self.find_unpaired_names
    self.get_unpaired_names self.get_good_files
  end

#-------------
  private

  def self.gallery_directory
    App.root.join(*%w[public images gallery]).realpath
  end

  def self.gallery_directory_entries
    self.gallery_directory.entries.map &:to_s
  end

  def self.get_bad_names
    self.get_files.last
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

  def self.get_good_files
    self.get_files.first
  end

  def self.get_names(files)
    files.map(&:filename).sort
  end

  def self.get_unpaired_names(files)
    th='-t' # Thumbnail flag in file names before the extension.
    a=self.get_names files
    self.get_names( files.reject do |e|
      x=Pathname.new(s=e.filename).extname
      main=s.chomp x
      a.include? e.is_thumbnail ? main.chomp(th)+x : main+th+x
    end )
  end

end
