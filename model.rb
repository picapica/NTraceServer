#!/usr/bin/env ruby
# encoding: utf-8

require './common'

DataMapper::Property::String.length(255)
DataMapper::Model.raise_on_save_failure = true

dbConfig = YAML.load_file(File.exists?('./config/database.yml') ? './config/database.yml' : './config/database.yml.default')
dbConfig.each do |repository, config|
  DataMapper.setup(repository, config)
end

class Task
  include DataMapper::Resource

  property :id, Serial

  property :created_by, String, :required => true

  property :description, String, :required => true, :length => 4096
end

DataMapper.finalize
DataMapper.auto_upgrade!
