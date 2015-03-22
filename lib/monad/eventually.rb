class Eventually
  def initialize(&block)
    @block = block
  end

  def self.from_value(value)
    Eventually.new do
      value
    end
  end

  def bind(&block)
    Eventually.new do
      result = @block.call
      block.call(result).value
    end
  end

  def value
    @block.call
  end
end
