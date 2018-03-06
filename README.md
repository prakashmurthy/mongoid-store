[![Build Status](https://travis-ci.org/prakashmurthy/mongoid-store.svg?branch=master)](https://travis-ci.org/prakashmurthy/mongoid-store)

MongoidStore
------------

ActiveSupport Mongoid 3 Cache store, strongly  based on the 'mongoid_store'
gem by Andre Meij (see his orginial LICENSE)

unlike the the original gem this version works with both rails3 and rails4,
and handles any object in any encoding (remember mongo is utf8 only)

Why?
----

mongoid-store is not as fast as redis-store.  in my tests inserting 10_000
random strings takes about 6 seconds for mongoid-store and 2 for redis-store.

in our (@dojo4) applications we use mongoid-store to reduce the number of
requirements when applications are young: avoiding the need to setup *two*
highly avaiable RAM devouring db services (redis + mongo).  instead we can
simply configure our applications to use a solid mongo service like
http://www.objectrocket.com/ - which provides a highly available and
automatically scalable mongo layer, two app servers, a load balancer, are
we're pretty set.  we also like to put all our images in mongo using
mongoid-grid_fs (or s3) and even our background jobs so, at the end of the
day, mongoid-store is aimed at keeping new application deployment simple and
relatively dependency free.



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

References
----------

http://www.slideshare.net/mongodb/mongodb-as-a-fast-and-queryable-cache
http://stackoverflow.com/questions/10317732/why-use-redis-instead-of-mongodb-for-caching

