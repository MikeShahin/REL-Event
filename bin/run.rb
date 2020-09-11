require 'pry'
require 'open-uri'
require 'net/http'
require 'nokogiri'
require 'json'
require 'colorize'

require_relative "key.rb"
require_relative "../lib/CLI.rb"
require_relative "../lib/API.rb"
require_relative "../lib/events.rb"

CLI.new.run