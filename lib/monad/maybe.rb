module Monad
  class Maybe
    def initialize(value)
      @value = value
    end

    def self.lift(value)
      Maybe.new value
    end

    attr_reader :value

    def fmap(proc)
      if @value.nil?
        self
      else
        Maybe.new(proc.call(@value))
      end
    end

    def apply(maybe)
      if @value.nil?
        self
      else
        maybe.fmap @value
      end
    end

    def bind(&block)
      if @value.nil?
        self
      else
        block.call(value)
      end
    end
  end
end
