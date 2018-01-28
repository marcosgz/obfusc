# frozen_string_literal: true

require 'obfusc/commands/concerns/encryptor_command_base'

module Obfusc
  # Perform tasks related `crypt` command
  class CryptCommand < Obfusc::EncryptorCommandBase
    # rubocop:disable MethodLength
    def show_usage
      usage = <<-TEXT.gsub('      ', '')
      Usage:
      $ obfusc crypt <* #{COMMANDS.join('|')}> <* from> <to>
        <* > Required arguments

      Action:
        move: Files will be moved to the target.
        copy: Keep existing files and generate a copy.

      Files:
        from: Relative or absolute of obfuscated directory/file. You can also use wildcards like "*" or "**".
        to: Relative or absolute directory where un-obfuscated files will be stored. (Default to current directory)
      TEXT
      puts usage
    end
    # rubocop:enable MethodLength

    protected

    def files
      Dir.glob(@from).each_with_object({}) do |relative_path, memo|
        memo[relative_path] = @config.encryptor.decrypt(relative_path)
      end
    end
  end
end
