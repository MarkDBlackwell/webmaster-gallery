class App
# %%mo%%app

 def self.root            () Gallery::Application.root                   end
 def self.session_options () Gallery::Application.config.session_options end
 def self.webmaster       () Gallery::Application.config.webmaster       end

#-> App.root
#-> App.session_options
#-> App.webmaster

end
