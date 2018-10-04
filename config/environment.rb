require 'bundler'
require "colorize"
require 'uri'

Bundler.require
ActiveRecord::Base.logger = nil
ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
require_all 'lib'
