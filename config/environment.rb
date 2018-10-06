require 'bundler'
require "colorize"
require 'uri'
require 'gmail'
require 'net/smtp'
# require 'gmail_xoauth'


Bundler.require
ActiveRecord::Base.logger = nil
ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
require_all 'lib'
