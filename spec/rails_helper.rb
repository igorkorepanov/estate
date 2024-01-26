# frozen_string_literal: true

require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require 'rails/all'

config = YAML.safe_load(IO.read("#{File.dirname(__FILE__)}/support/active_records.yml"))
ActiveRecord::Base.establish_connection(config['sqlite3'])
require "#{File.dirname(__FILE__)}/support/active_records.rb"

require 'sequel'
DB = Sequel.sqlite
require "#{File.dirname(__FILE__)}/support/sequel.rb"
