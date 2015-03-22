class Maybe
  def initialize(value)
    @value = value
  end

  def self.from_value(value)
    Maybe.new value
  end

  attr_reader :value

  def bind(&block)
    if @value.nil?
      self
    else
      block.call(value)
    end
  end
end
