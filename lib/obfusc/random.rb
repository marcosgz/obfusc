# frozen_string_literal: true

module Obfusc
  # Grab most comon characters and generate a random list of key and value
  class Random
    DIGIT = (0x30..0x39).map(&:chr)
    ALPHA = (0x41..0x5a).map(&:chr) + (0x61..0x7a).map(&:chr)
    SPECIAL = [
      ' ', '-', '_', ',', ':', ';', '=', '@', '[', ']', '(', ')', '{', '}', '|'
    ].freeze

    def self.generate!
      hash = {}
      randonize!(hash, DIGIT + ALPHA)
      randonize!(hash, SPECIAL)
      hash
    end

    private_class_method def self.randonize!(memo, source)
      source.sort_by { rand }.each do |char|
        list = source - (memo.values & source)
        loop do
          memo[char] = list.sample
          break if list.size <= 1
          break if memo[char] != char
        end
      end
      memo
    end
  end
end
