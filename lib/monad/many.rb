module Monad
  class Many
    def initialize(values)
      @value = values
    end

    def self.lift(value)
      Many.new([value])
    end

    attr_reader :value

    def bind(&block)
      Many.new(@value.map(&block).map(&:value).flatten)
    end
  end
end
