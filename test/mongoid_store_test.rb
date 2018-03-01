require 'test_helper'
require "caching_test"

class MongoidStoreTest < ActiveSupport::TestCase
  def setup
    @cache = ActiveSupport::Cache.lookup_store(:mongoid_store)
    ::ActiveSupport::Cache::MongoidStore::Storage.delete_all
  end

  include ::CacheStoreBehavior
end
