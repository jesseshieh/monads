module Monad
  class State
    def initialize(&block)
      @block = block
    end

    def self.lift(value)
      State.new do |state|
        [value, state]
      end
    end

    def run(initial_state)
      @block.call(initial_state)
    end

    def bind(&block)
      State.new do |state|
        _, new_state = run(state)
        block.call(new_state)
      end
    end
  end
end
