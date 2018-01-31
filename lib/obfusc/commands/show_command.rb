# frozen_string_literal: true

module Obfusc
  # Perform tasks related `show` command
  class ShowCommand

    def initialize(config, source)
      @config = config
      @source = source
    end

    def self.call(config, *args)
      source = args.first
      model = new(config, source)
      model.public_send(File.exist?(source.to_s) ? :run : :show_usage)
    end

    def run
      files.each do |from, to|
        puts "#{from}:"
        puts "---> #{to}"
      end
    end

    def show_usage
      usage = <<-TEXT.gsub('      ', '')
      Usage:
      $ obfusc show <source>

      Files:
        source: Relative or absolute directory where obfuscated files are stored. (Default to current directory)
      TEXT
      puts usage
    end

    protected

    def files
      recursive_from = File.join(@source, '**/{.*,*}') if File.directory?(@source)
      Dir.glob(recursive_from || @source).each_with_object({}) do |path, memo|
        next if File.directory?(path)
        next if File.symlink?(path)
        basename = File.basename(path)
        next unless @config.encryptor.obfuscated?(basename)
        memo[path] = @config.encryptor.decrypt(basename)
      end
    end
  end
end
