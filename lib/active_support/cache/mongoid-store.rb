# encoding: utf-8
#
require 'mongoid'
require 'active_support'

module ActiveSupport
  module Cache
    class MongoidStore < Store
      class Entry
        include Mongoid::Document
        include Mongoid::Timestamps

        field :key,  type: String
        field :data, type: String
        field :expires_in, type: DateTime, default: ->{ 1.hour.from_now }

        def expired?
          expires_at < Time.now
        end

        def value
          data
        end
      end

      def initialize(options = {})
        options[:expires_in] ||= 1.hour
        super(options)
      end

      protected

      def write_entry(key, entry, options)
        value      = entry.instance_variable_get(:@value)
        created_at = entry.instance_variable_get(:@created_at)
        expires_in = entry.instance_variable_get(:@expires_in)

        cache_entry = Entry.new(key: key, data: value, created_at: created_at, expires_in: expires_in)
        cache_entry.upsert
      end

      def read_entry(key, options)
        entry = Entry.find_by(key: key)
        ActiveSupport::Cache::Entry.new(key: key, value: entry.value, created_at: entry.created_at, expires_in: entry.expires_in)
      end

      def delete_entry(key, options)
        Entry.find_by(key: key).delete
      end
    end
  end
end
