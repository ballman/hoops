#!/usr/bin/ruby
require File.dirname(__FILE__) + "/../config/environment"
require 'rubygems'
gem 'activerecord'
require 'team'

Team.find(:all).each { | team |
  puts team.name
}
