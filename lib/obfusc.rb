# frozen_string_literal: true

require 'optparse'
require 'yaml'

require 'obfusc/cli'
require 'obfusc/config'
require 'obfusc/random'
require 'obfusc/version'

Dir["#{File.dirname(__FILE__)}/obfusc/commands/*_command.rb"].each do |file|
  require file
end

# Script to obfuscate directories or files using a unique token/secret key.
module Obfusc
end
