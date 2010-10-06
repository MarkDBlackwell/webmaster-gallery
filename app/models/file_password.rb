class FilePassword < ActiveRecord::Base
  establish_connection :adapter => :nulldb
end
