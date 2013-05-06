#!/usr/bin/env ruby -w
Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

require 'rubygems'
require 'bundler'
Bundler.require

require './common'
require './model'

require './app'
run NTraceServer
