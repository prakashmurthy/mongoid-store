module ActiveSupport
  module Cache
    class MongoidStore
      class Storage < Entry
        include Mongoid::Document
        include Mongoid::Timestamps

        field :key,  type: String
        field :data, type: String
        field :expires_in, type: Float, default: 60.0
        field :expires_at, type: Time, default: ->{ Time.now + expires_in }

        index({ key: 1}, { unique: true, name: "key_index", background: true })

        def expired?
          created_at.to_f + expires_in < Time.now.to_f
        end

        def value
          data
        end

        def compress(value)
          Base64.encode64(Marshal.dump(value))
        end

        def uncompress(value)
          Marshal.load(Base64.encode64(value))
        end
      end
    end
  end
end
