class Functor
  def initialize(value)
    @value = value
  end

  attr_reader :value

  def fmap(&block)
    Functor.new(block.call(@value))
  end
end
