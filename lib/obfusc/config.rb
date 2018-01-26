# frozen_string_literal: true

module Obfusc
  # Get/Set configurations with its default values.
  class Config
    attr_accessor :config_path, :extension, :verbose

    def initialize(options)
      @config_path = options[:config_path]
      @config_path ||= File.join(ENV['HOME'], '.obfusc.cnf')

      @extension = options[:extension] || 'obfusc'
      @verbose = options[:verbose] || false
    end
  end
end
