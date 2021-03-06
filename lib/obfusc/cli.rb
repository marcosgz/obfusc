# frozen_string_literal: true

module Obfusc
  # This model receive and process ARGV from ./exe/obfusc script
  class CLI
    VALID_COMMANDS = %w[setup crypt decrypt show].freeze

    attr_reader :argumetns, :options

    def initialize(arguments)
      @arguments = arguments
      @options = {}
    end

    def run
      configure
      perform(@arguments.shift)
    end

    protected

    def perform(command)
      unless VALID_COMMANDS.include?(command)
        puts parser.help
        return
      end
      config = Obfusc::Config.new(@options)
      class_name = "#{command[0].upcase}#{command[1..-1]}Command"
      Obfusc.const_get(class_name).call(config, *@arguments)
    end

    def configure
      parser.parse!(@arguments)
    end

    # rubocop:disable BlockLength,MethodLength,AbcSize
    def parser
      @parser = OptionParser.new do |opts|
        opts.banner = 'Usage: obfusc <command> <arguments> <options>'
        opts.separator ''
        opts.separator 'Commands:'
        VALID_COMMANDS.each do |command|
          opts.separator "    * #{command}"
        end

        opts.separator ''
        opts.separator 'Specific options:'

        opts.on('-c', '--config FILENAME',
                'Using a different ".obfusc.cnf" filename') do |filename|
          @options[:config_path] = filename
        end

        opts.on(
          '-e',
          '--extension STRING',
          'Specify a custom file extension. (Default to "obfc")'
        ) do |extension|
          @options[:extension] = extension
        end

        opts.on(
          '-p',
          '--prefix STRING',
          'Specify a custom file prefix. (Default to "obfc")'
        ) do |prefix|
          @options[:prefix] = prefix
        end

        opts.on('-v', '--[no-]verbose', 'Run verbosely') do |v|
          @options[:verbose] = v
        end

        opts.on(
          '-s',
          '--[no-]simulate',
          'Do a simulate run without executing actions'
        ) do |v|
          @options[:simulate] = v
        end

        opts.separator ''
        opts.separator 'Common options:'

        opts.on_tail('-h', '--help', 'Show this message') do
          puts opts
          exit
        end
      end
    end
    # rubocop:enable BlockLength,MethodLength,AbcSize
  end
end
