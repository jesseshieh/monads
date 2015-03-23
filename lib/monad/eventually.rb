require 'applicative_functor'

module Monad
  class Eventually
    include ApplicativeFunctor

    def initialize(value)
      @value = value
    end

    def self.lift(value)
      Eventually.new -> {
        value
      }
    end

    def bind(&block)
      Eventually.new -> {
        block.call(@value.call).value
      }
    end

    def fmap(proc)
      Eventually.new -> {
        proc.call(@value.call)
      }
    end

    def value
      @value.call
    end
  end
end
