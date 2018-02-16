require 'test_helper'
require 'mongoid-store'
require "active_support/cache"
require "caching_test"

class MongoidStoreTest < ActiveSupport::TestCase
  def setup
    @cache = ActiveSupport::Cache.lookup_store(:mongoid_store)
  end

  include ::CacheStoreBehavior
end
