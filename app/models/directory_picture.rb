class DirectoryPicture
  include ActiveModel::Validations

  attr_accessor :filename

  validates_each :filename do |record, attr, value|
    record.errors.add attr, 'contains /' if value.include? ?/
  end

  class FindError < Exception
  end

  def self.find (*args)
    raise FindError unless args.include? :all
    self.get_good_files
  end

  def self.find_bad_names
    self.get_bad_names
  end

  def self.find_unpaired_names
    th='-t' # Thumbnail flag in file names before the extension.
    files=self.get_good_files
    names=files.map &:filename
    files.reject do |e|
      s=e.filename
      x=s.extname
      main=s.to_s.chomp x
      names.include? e.is_thumbnail ? main.chomp(th)+x : main+th+x
    end.map &:filename
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
#    web_picture_extensions = %w[ .gif .giff .jpeg .jpg .png ]
    allowed_single_characters=Regexp.escape '-.'
    forbidden_ascii=Regexp.new "[^A-Za-z0-9#{allowed_single_characters}]"
    bad_names=[]
    directory=self.gallery_directory
    good_files=self.gallery_directory_entries.map do |entry|
      bad_entry=entry.gsub! forbidden_ascii, '?'
      (bad_names << (Pathname.new bad_entry); next) if bad_entry
      e=directory.join entry
      b=e.basename
      x=b.extname
      name=b.to_s.chomp x
#      (bad_names << b; next) if (!web_picture_extensions.include? x) || (name.
#          ends_with? '-t-t')
      (bad_names << b; next) if (name.ends_with? '-t-t')
      begin
        next unless e.file?
        mtime=e.mtime
      rescue ArgumentError
        (bad_names << (Pathname.new '-?-'); next)
      end
      file_struct.new mtime, b, (name.ends_with? '-t')
    end.compact.sort{|b,a| a.time<=>b.time}
    [good_files, bad_names]
  end

  def self.get_good_files
    self.get_files.first
  end

end
