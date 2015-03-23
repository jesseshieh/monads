require 'applicative_functor'

module Monad
  class Log
    include ApplicativeFunctor

    def initialize(payload)
      @value, @log = payload
    end

    attr_reader :value
    attr_reader :log

    def self.lift(value)
      Log.new([value, []])
    end

    def bind(&block)
      new_value, new_log = block.call(@value)
      Log.new([new_value, @log + [new_log]])
    end
  end
end
