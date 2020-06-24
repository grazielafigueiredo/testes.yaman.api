# frozen_string_literal: true

require 'factory_bot'
require 'httparty'
require 'json'
require 'rspec'

CONFIG = YAML.load_file(File.dirname(__FILE__) + '/config/hml.yml')
