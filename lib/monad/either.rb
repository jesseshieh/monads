class Either
  class Success
    def initialize(value)
      @value = value
    end

    attr_reader :value

    def success?
      true
    end

  end

  class Failure
    def initialize(value)
      @value = value
    end

    attr_reader :value

    def success?
      false
    end
  end

  def initialize(value)
    @value = value
  end

  attr_reader :value

  def self.from_value(value)
    Either.new(Success.new(value))
  end

  def value
    @value.value
  end

  def bind(&block)
    if @value.success?
      Either.new(block.call(@value.value))
    else
      self
    end
  end
end
