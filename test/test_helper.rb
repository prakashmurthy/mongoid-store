require 'active_support/test_case'
require 'mongoid'
gem 'minitest'
require 'minitest/autorun'
require "minitest/mock"
require 'pry'
require "active_support/cache"
require 'mongoid-store'

Mongoid.load!(File.expand_path("../mongoid.yml", __FILE__), :test)
::ActiveSupport::Cache::MongoidStore::Storage.create_indexes

# Copied from https://raw.githubusercontent.com/rails/rails/cfb1e4dfd8813d3d5c75a15a750b3c53eebdea65/activesupport/lib/active_support/testing/method_call_assertions.rb for test methods.

def assert_called(object, method_name, message = nil, times: 1, returns: nil)
  times_called = 0

  object.stub(method_name, proc { times_called += 1; returns }) { yield }

  error = "Expected #{method_name} to be called #{times} times, " \
    "but was called #{times_called} times"
  error = "#{message}.\n#{error}" if message
  assert_equal times, times_called, error
end

def assert_called_with(object, method_name, args = [], returns: nil)
  mock = Minitest::Mock.new

  if args.all? { |arg| arg.is_a?(Array) }
    args.each { |arg| mock.expect(:call, returns, arg) }
  else
    mock.expect(:call, returns, args)
  end

  object.stub(method_name, mock) { yield }

  mock.verify
end

def assert_not_called(object, method_name, message = nil, &block)
  assert_called(object, method_name, message, times: 0, &block)
end

def stub_any_instance(klass, instance: klass.new)
  klass.stub(:new, instance) { yield instance }
end
