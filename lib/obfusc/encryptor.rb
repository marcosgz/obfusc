# frozen_string_literal: true

module Obfusc
  # Recursive find files from origin or pattern
  class Encryptor
    SEP_FROM = '/'.freeze
    SEP_TO = '___|___'.freeze

    def initialize(config)
      @config = config
      @prefix = "#{config.extension}__"
      @suffix = ".#{config.extension}"
    end

    def encrypt(path)
      crypted_filename = expand_path_for_encrypt(path).map do |step|
        step.chars.map { |char| charlist[char] || char }.join
      end.join(SEP_TO)

      [@prefix, crypted_filename, @suffix].join
    end

    def decrypt(path)
      expand_path_for_decrypt(path).join(SEP_FROM)
    end

    def obfuscated?(file)
      !!(file =~ obfuscated_expression)
    end

    protected

    def expand_path_for_encrypt(path)
      parts = []
      path.split(SEP_FROM).each do |part|
        parts.push(*try_decrypt(part).split(SEP_FROM))
      end
      parts
    end

    def expand_path_for_decrypt(path, memo = [])
      return memo if String(path).length.zero?

      if path =~ obfuscated_expression
        parts = normalize(path).split(SEP_TO)
        return [*memo, *parts.map { |part| decrypt_segment(part) }]
      end

      dir, new_path = path.split(SEP_FROM, 2)
      expand_path_for_decrypt(new_path, [*memo, dir])
    end

    def decrypt_segment(segment)
      segment.chars.map { |char| charlist.key(char) || char }.join
    end

    def try_decrypt(step)
      return step unless step =~ obfuscated_expression
      decrypt(step)
    end

    def obfuscated_expression
      /^(#{Regexp.escape(@prefix)}).*(#{Regexp.escape(@suffix)})$/
    end

    def charlist
      @charlist ||= begin
        keys = @config.token.split('')
        values = @config.secret.split('')
        Hash[keys.zip(values)]
      end
    end

    def normalize(path)
      path.sub!(/^(#{Regexp.escape(@prefix)})/, '')
      path.sub!(/(#{Regexp.escape(@suffix)})$/, '')
      path
    end
  end
end
