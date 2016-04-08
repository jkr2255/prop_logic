$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'rubygems'
require 'prop_logic'
require 'scrutinizer/ocular'
Scrutinizer::Ocular.watch!
