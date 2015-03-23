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
      value = run
      if value.is_a? Proc
        Eventually.new -> {
          ->(x) {
            value.call(proc.call(x))
          }
        }
      else
        Eventually.new -> {
          proc.call(value)
        }
      end
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
