# encoding: utf-8
#
require 'mongoid'
require 'active_support'

module ActiveSupport
  module Cache
    class MongoidStore < Store

      require_relative 'mongoid_store/storage.rb'

      def initialize(options = {})
        options[:expires_in] ||= 1.minute
        super(options)
      end

      def increment(key, amount = 1, options = nil)
        modify_value(key, amount, options)
      end

      def decrement(key, amount = 1, options = nil)
        modify_value(key, -amount, options)
      end

      protected

      def write_entry(key, entry, options)
        value      = entry.instance_variable_get(:@value)
        created_at = entry.instance_variable_get(:@created_at)
        expires_in = entry.instance_variable_get(:@expires_in)
        expires_at = Time.now + expires_in if expires_in

        cache_entry = Storage.find_or_initialize_by(key: key)
        race_condition_ttl = options[:race_condition_ttl]
        compressed = entry.instance_variable_get(:@compressed)

        if race_condition_ttl && expires_in && expires_in > 0
          expires_in += race_condition_ttl
        end

        cache_entry.save!

        if compressed
          value = Marshal.load(Zlib::Inflate.inflate(value))
        end

        cache_entry.update(data: Marshal.dump(value),
                           created_at: created_at,
                           expires_in: expires_in,
                           expires_at: expires_at)
      end

      def read_entry(key, options)
        entry = Storage.where(key: key).first
        return nil unless entry

        value = Marshal.load(entry.value)

        as_entry = ActiveSupport::Cache::Entry.new(value, expires_in: entry.expires_in)
        as_entry.instance_variable_set(:@created_at, entry.created_at.to_f)

        as_entry
      end

      def delete_entry(key, options)
        Storage.find_by(key: key).delete
      end

      def modify_value(key, amount, options)
        entry = Storage.where(key: key).first
        number = Marshal.load(entry.value)
        number = number.to_i if number == number.to_i.to_s
        updated_value = number + amount
        entry.update(data: Marshal.dump(updated_value))
        updated_value
      end
    end
  end
end
