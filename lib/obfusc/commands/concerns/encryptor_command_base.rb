# frozen_string_literal: true

module Obfusc
  # Commom methods shared between CryptCommand and DecryptCommand models.
  # Children models only overwrite `show_usage` and files.
  class EncryptorCommandBase
    COMMANDS = %w[move copy].freeze
    CURRENT_DIR = './'.freeze

    def initialize(config, from, to)
      @config = config

      @from = from || CURRENT_DIR
      @to = to || CURRENT_DIR
    end

    def self.call(config, *args)
      command, from, to = args
      model = new(config, from, to)
      command = 'show_usage' unless COMMANDS.include?(command)
      model.public_send(command)
    end

    def show_usage
      raise NotImplementedError
    end

    def files
      raise NotImplementedError
    end

    def move
      files.each_with_index do |(from, to), index|
        create_target_base_directory if index.zero?
        create_directory_from_file(to)
        @config.log("mv #{from} #{to}")
        @config.dry_run do
          FileUtils.mv(from, to, verbose: @config.verbose?)
        end
      end.size
    end

    def copy
      files.each_with_index do |(from, to), index|
        create_target_base_directory if index.zero?
        create_directory_from_file(to)
        @config.log("cp #{from} #{to}")
        @config.dry_run do
          FileUtils.cp(from, to, verbose: @config.verbose?)
        end
      end.size
    end

    protected

    def create_directory_from_file(path)
      return if File.directory?(path)
      dirname = File.dirname(path)
      return if File.expand_path(dirname) == File.expand_path(@to)

      @config.log("mkdir -p #{dirname}")
      @config.dry_run { FileUtils.mkdir_p(dirname) }
    end

    def create_target_base_directory
      return if @to == CURRENT_DIR
      return if File.directory?(@to)

      @config.log("mkdir -p #{@to}")
      @config.dry_run { FileUtils.mkdir_p(@to) }
    end
  end
end
