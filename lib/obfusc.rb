# frozen_string_literal: true

require 'optparse'
require 'obfusc/cli'
require 'obfusc/version'
require 'obfusc/random'

Dir["#{File.dirname(__FILE__)}/obfusc/commands/*_command.rb"].each do |file|
  require file
end

# Script to obfuscate directories or files using a unique token/secret key.
module Obfusc
end
