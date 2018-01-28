# frozen_string_literal: true

module Obfusc
  # Commom methods shared between CryptCommand and DecryptCommand models.
  # Children models only overwrite `show_usage` and files.
  class EncryptorCommandBase
    COMMANDS = %w[move copy].freeze

    def initialize(config, from, to)
      @config = config
      @from = from
      @to = to
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
      files.each do |from, to|
        create_dir(to)
        @config.log("mv #{from} #{to}")
        @config.dry_run do
          FileUtils.mv(from, file_to, verbose: @config.verbose?)
        end
      end
    end

    def copy
      files.each do |from, to|
        create_dir(to)
        @config.log("cp #{from} #{to}")
        @config.dry_run do
          FileUtils.cp(from, file_to, verbose: @config.verbose?)
        end
      end
    end

    protected

    def create_dir(path)
      dirname = File.dirname(path)
      return unless File.exist?(dirname)

      @config.log("mkdir -p #{dirname}")
      @config.dry_run { FileUtils.mkdir_p(dirname) }
    end
  end
end
