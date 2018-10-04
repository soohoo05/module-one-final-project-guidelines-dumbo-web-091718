require_relative '../config/environment'
# require 'net/http'
# require 'open-uri'
# require 'json'
# test = test_api.rb
require 'pry'

cli=Cliinterface.new()

ActiveRecord::Base.logger = nil
