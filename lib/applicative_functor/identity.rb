module ApplicativeFunctor
  class Identity
    def initialize(&block)
      @block = block
    end

    def fmap(&block)
      Identity.new do |value|
        new_value = @block.call(value)
        block.call(new_value)
      end
    end

    def value(value)
      @block.call(value)
    end
  end
end
