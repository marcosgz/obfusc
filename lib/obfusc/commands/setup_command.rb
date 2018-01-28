# frozen_string_literal: true

module Obfusc
  # Perform tasks related `setup` command
  class SetupCommand
    COMMANDS = %w[generate show].freeze

    def initialize(config)
      @config = config
    end

    def self.call(config, *args)
      model = new(config)
      command = args.first
      command = 'show_usage' unless COMMANDS.include?(command)
      model.public_send(command)
    end

    def show_usage
      puts "Usage:\nobfusc setup <#{COMMANDS.join('|')}>"
    end

    def generate
      File.open(config_file, 'w') do |f|
        f.write tokenize(Obfusc::Random.generate!)
      end
    end

    def show
      unless File.exist?(config_file)
        puts "#{config_file} does not exist.\nUse: `obfusc setup generate'"
        return
      end
      YAML.load_file(config_file).each do |key, value|
        puts "#{key}:"
        puts "---> #{value.inspect}"
      end
    end

    protected

    def tokenize(characters_hash)
      token = ''
      secret = ''
      characters_hash.sort_by { rand }.each do |key, value|
        token += key
        secret += value
      end
      YAML.dump('token' => token, 'secret' => secret)
    end

    def config_file
      @config.config_path
    end
  end
end
