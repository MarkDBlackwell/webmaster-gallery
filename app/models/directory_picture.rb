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
    self.get_files
  end

  def self.find_bad_names
    filenames=[]
  end

  def self.find_unpaired_names
    th='-t'
    files=self.get_files
    fn=files.map &:filename
    files.reject do |e|
      s=e.filename
      x=s.extname
      b=s.to_s.chomp x
      case
      when e.is_picture
        fn.include? b+th+x
      when e.is_thumbnail
        fn.include? b.chomp(th)+x
      end
    end.map(&:filename)
  end

#-------------
  private

  def self.files_in_descending_order_by_modification_time
    `ls -dlt --time-style=full-iso #{self.gallery_directory.join '*'} | \
     cut --fields=6-7,9 --delimiter=' '`
  end  

  def self.gallery_directory
    App.root.join *%w[public images gallery]
  end

  def self.get_files
    th='-t'
    dtp_s=Struct.new :date, :time, :path
    file_s=Struct.new :time, :filename, :is_thumbnail, :is_picture
    files_in_descending_order_by_modification_time.split("\n").map{|e|
        dtp_s.new *e.split}.map do |e|
      time=e.time.split ':'
      seconds=time.pop
      t=Time.local *(e.date.split '-') + time + (seconds.split '.')
      s=(Pathname.new e.path).basename
      x=s.extname
      b=s.to_s.chomp x
      bt=b.ends_with? th
      file_s.new t, s, bt, ! bt
    end
  end

end
