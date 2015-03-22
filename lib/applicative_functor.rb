class ApplicativeFunctor
  def initialize(&block)
    @block = block
  end

  def fmap(&block)
    ApplicativeFunctor.new do |value|
      new_value = @block.call(value)
      block.call(new_value)
    end
  end

  def value(value)
    @block.call(value)
  end
end
