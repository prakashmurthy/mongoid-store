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
        field :expires_at, type: DateTime, default: ->{ 1.hour.from_now }

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
        entry = Entry.new(key: key, data: entry)
        entry.upsert
      end

      def read_entry(key, options)
        entry = Entry.find_by(key: key)
        entry.value
      end

      def delete_entry(key, options)
        Entry.find_by(key: key).delete
      end
    end
  end
end
