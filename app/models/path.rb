class Path

  a=[ %w[root], %w[webmaster] ]
  %w[app config].each_with_index do |group,i|
    a.at(i).each do |e|
      self.class_eval "def self.#{e}() #{group}.#{e} end"
#     For example:  def self.webmaster() config.webmaster end
    end
  end

#-------------
  private

  def self.app() Gallery::Application end

  def self.config() app.config end

end
