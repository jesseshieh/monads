module Functor
  class Identity
    def initialize(value)
      @value = value
    end

    attr_reader :value

    def fmap(&block)
      Identity.new(block.call(@value))
    end
  end
end
