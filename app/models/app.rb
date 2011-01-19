class App
# %%mo%%app

  %w[  group_1    group_2                          ].zip([
       ['root'],  %w[ session_options  webmaster]
      ]).each do |g,methods|
    methods.each{ |m| self.class_eval "def self.#{m}() #{g}.#{m} end" }
  end

#-------------
  private

  def self.group_1()  Gallery::Application end
  def self.group_2()  group_1.config       end

end
