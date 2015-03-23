require 'applicative_functor'

module Monad
  class State
    include ApplicativeFunctor

    def initialize(value)
      @value = value
    end

    attr_reader :value

    def self.lift(value)
      State.new ->(state) {
        [value, state]
      }
    end

    def fmap(proc)
      State.new ->(s) {
        result, new_state = @value.call(s)
        [proc.call(result), new_state]
      }
    end

    def apply(state)
      State.new ->(s) {
        proc, new_state = @value.call(s)
        state.fmap(proc).run(new_state)
      }
    end

    def run(initial_state)
      @value.call(initial_state)
    end

    def bind(&block)
      State.new ->(state) {
        _, new_state = run(state)
        block.call(new_state)
      }
    end
  end
end
