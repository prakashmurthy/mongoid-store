source "http://rubygems.org"

rails_version = ENV["RAILS_VERSION"] || "default"

mongoid = case rails_version
          when "5.1.5"
            "~> 5.0"
          when "4.2.10", "default"
            "~> 3.0"
          end

gem 'mongoid', "~> 6.0"
gem 'activesupport', "~> 5.1.0"
# gemspec

gem 'rake'
gem 'minitest'
gem 'pry'
