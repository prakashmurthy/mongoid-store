require 'active_support/test_case'
require 'mongoid'
gem 'minitest'
require 'minitest/autorun'
require 'pry'

Mongoid.load!(File.expand_path("../mongoid.yml", __FILE__), :test)
