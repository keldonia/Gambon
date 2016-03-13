module Gambon

end

Dir.global('./app/models/*.rb')
Dir.global('./app/controllers/*.rb')

require_relative './ORM/sql_object'
require_relative './db_connection'
require_relative './controller_base'
require_relative './router'
require_relative './server'
require_relative '../bin/server'
require_relative './session'
require '../db/seeds'
