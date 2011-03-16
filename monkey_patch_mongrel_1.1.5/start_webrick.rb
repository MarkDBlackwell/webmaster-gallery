p Time.now, 'in '+__FILE__

# Tested on:
#   Architecture x86_64
#   cPanel 11.28.86
#   cPanel Pro 1.0 (RC1)
#   Linux 2.6.9-89.31.1.ELsmp
#   Mongrel 1.1.5 (version used by cPanel)
#   Rails 3.0.3
#   Ruby 1.8.7 patchlevel 330

module MyStartup
  require 'pathname'

  PROGRAM_FILE=Pathname(__FILE__).realpath
  pfd=[]; PROGRAM_FILE.descend{|e| pfd << e}
  USER_HOME=pfd.at 1
  APP_ROOT= pfd.at -3
  SERVER='webrick'
  PORT='12009'

#  MY_RAILS_ENV='development'
  MY_RAILS_ENV='production'

  ARGUMENTS="--environment=#{MY_RAILS_ENV} --port=#{PORT}"
  REDIRECT_OUTPUT='development'==MY_RAILS_ENV ? '' : '> /dev/null'

  class GemPathEntry
    SYSTEM     = Pathname('/').join *%w[   usr    lib    ruby  gems  1.8 ]
    USER       = USER_HOME    .join *%w[  .gem           ruby        1.8 ]
    APP_BUNDLE = APP_ROOT     .join *%w[ vendor  bundle  ruby        1.8 ]
  end
  MY_GEM_HOME= GemPathEntry::USER
  MY_GEM_PATH=[GemPathEntry::APP_BUNDLE, GemPathEntry::USER, GemPathEntry::SYSTEM].join ':'

# We might need Bundler in system gems. Or, as working now, in user (.gem) gems; I don't remember.

# The following line doesn't work because Bundler (1.0.10) "bundle install --binstubs" rewrites gem executables to invoke Bundler:
##       r = APP_ROOT.
  r = GemPathEntry::APP_BUNDLE
  RAILS_COMMAND=['exec',r.join(*%w[bin rails]),'server',SERVER,ARGUMENTS,REDIRECT_OUTPUT].join ' '

  REQUIRED_ENVIRONMENT_VARIABLES=[
      "HOME=#{      USER_HOME    }",
      "RAILS_ENV=#{ MY_RAILS_ENV }",
      "GEM_HOME=#{  MY_GEM_HOME  }",
      "GEM_PATH=#{  MY_GEM_PATH  }",
      ].join ' '

  def self.stop_process(name,pid,signal)
    begin
      p "Stopping #{name} pid #{pid} at #{Time.now}."
      Process.kill signal, pid
      p Process.waitall
      p "#{name} finished at #{Time.now}."
    rescue Errno::EINVAL, Errno::ESRCH
      p "No #{name} process #{pid}."
    end
# Sometimes there are other processes, I don't know why; so wait for them.
# Got error, undefined local variable or method `pwa':
##    p pwa, "All child processes finished at #{Time.now}." unless (pwa=Process.waitall).empty?
    pwa=Process.waitall
    p pwa, "All child processes finished at #{Time.now}." unless pwa.empty?
  end

# Rack (1.2.1) fails with Rails 3.0.3 and any Mongrel, although Webrick works, per:
# https://github.com/rack/rack/issues/35

  p Time.now
  p "Program name ($0) is #{$PROGRAM_NAME}"
  p "in #{PROGRAM_FILE}"
  p (c="export #{REQUIRED_ENVIRONMENT_VARIABLES}; cd #{APP_ROOT}; #{RAILS_COMMAND}")
  $LOAD_PATH.unshift APP_ROOT.join 'monkey_patch_mongrel_1.1.5'

  unless WEBRICK_MONITOR_PID=Process.fork # Mongrel doesn't stop all threads, so we use a process.
    Process.exec c unless WEBRICK_PID=Process.fork # Fork and replace another process.
    p "Starting Webrick pid #{WEBRICK_PID} at #{Time.now}."
    Signal.trap 'TERM' do
      stop_process 'Webrick', WEBRICK_PID, 'INT'
    end
    p Process.waitall
    p "Webrick finished (itself); stopping Mongrel at #{Time.now}."
    `#{s='mongrel_rails stop'}`
    p "'#{s}' finished at #{Time.now}."
    Process.exit
  end

  Kernel.at_exit do # Handle being stopped by Mongrel.
    stop_process 'Webrick monitor', WEBRICK_MONITOR_PID, 'TERM'
  end

end
