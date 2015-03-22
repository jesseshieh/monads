module Monad
  class Identity
    def initialize(value)
      @value = value
    end

    attr_reader :value

    def bind(&block)
      block.call(value)
    end
  end
end
