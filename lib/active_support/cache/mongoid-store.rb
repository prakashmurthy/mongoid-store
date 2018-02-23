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
        field :expires_in, type: Float, default: 60.0
        field :datatype, type: String, default: "String"

        index({ key: 1}, { unique: true, name: "key_index", background: true })

        def expired?
          created_at.to_f + expires_in < Time.now.to_f
        end

        def value
          data
        end
      end

     def initialize(options = {})
        options[:expires_in] ||= 1.hour
        super(options)
      end

      def increment(key)

      end

      def decrement(key)

      end

      protected

      def write_entry(key, entry, options)
        value      = entry.instance_variable_get(:@value)
        datatype   = value.class.to_s
        created_at = entry.instance_variable_get(:@created_at)
        expires_in = entry.instance_variable_get(:@expires_in)
        cache_entry = Entry.find_or_initialize_by(key: key)

        cache_entry.save!
        cache_entry.update(data: value, created_at: created_at, expires_in: expires_in, datatype: datatype)
      end

      def read_entry(key, options)
        entry = Entry.where(key: key).first
        return nil unless entry && !entry.expired?

        value = entry.value
        value = value.to_i if entry.datatype == "Fixnum"
        value = false if entry.datatype == "FalseClass"
        value = true  if entry.datatype == "TrueClass"
        value = Hash(value) if entry.datatype == "Hash"

        as_entry = ActiveSupport::Cache::Entry.new(value, expires_in: entry.expires_in)
        as_entry.instance_variable_set(:@created_at, entry.created_at.to_f)

        as_entry
      end

      def delete_entry(key, options)
        Entry.find_by(key: key).delete
      end
    end
  end
end
