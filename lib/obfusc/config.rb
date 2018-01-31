# frozen_string_literal: true

module Obfusc
  # Get/Set configurations with its default values.
  class Config
    attr_accessor :config_path, :extension, :verbose, :simulate, :prefix

    def initialize(options)
      @config_path = options[:config_path]
      @config_path ||= File.join(ENV['HOME'], '.obfusc.cnf')

      @extension = options[:extension] || 'obfusc'
      @prefix = options[:prefix] || 'obfusc'
      @verbose = options[:verbose] || false
      @simulate = options[:simulate] || false
    end

    %i[simulate verbose].each do |method|
      define_method "#{method}?" do
        public_send("#{method}") == true
      end
    end

    def encryptor
      @encryptor ||= Obfusc::Encryptor.new(self)
    end

    def token
      settings['token']
    end

    def secret
      settings['secret']
    end

    def log(msg)
      puts("DEBUG: #{msg}") if verbose?
    end

    def dry_run
      return unless block_given?

      yield unless simulate?
    end

    protected

    def settings
      @settings ||= YAML.load_file(config_path)
    rescue Errno::ENOENT
      puts "No such file #{config_path}."
      puts "Use: `obfusc setup generate' to generate it"
      {}
    end
  end
end
