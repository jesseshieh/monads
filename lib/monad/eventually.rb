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

    def fmap(proc)
      Eventually.new -> {
        proc.call(run)
      }
    end

    def apply(eventually)
      Eventually.new -> {
        eventually.fmap(run).run
      }
    end

    def bind(&block)
      Eventually.new -> {
        block.call(run).run
      }
    end

    def run
      @value.call
    end
  end
end
