MongoidStore
------------

ActiveSupport Mongoid 3 Cache store, strongly  based on the 'mongoid_store'
gem by Andre Meij (see his orginial LICENSE)

unlike the the original gem this version works with both rails3 and rails4,
and handles any object in any encoding (remember mongo is utf8 only)



Supports
--------

* Mongoid 3+
* Ruby 1.9.2+
* ActiveSupport 3+


Installation and Usage
----------------------

```bash
  # cli

  gem install mongoid-store
```

```ruby
  # Gemfile

  gem 'mongoid-store'
```

Direct usage

```ruby
  # direct usage

  require 'mongoid-store'

  store = ActiveSupport::Cache::MongoidStore.new
  store.write('abc', 123)

  store.read('abc')

  store.read('def')
  store.fetch('def'){ 456 }
  store.read('def')
```

Using MongoidStore with rails is as easy as:

```ruby
  # rails usage

  config.cache_store = :mongoid_store

  Rails.cache.write(:key, :val)
```
