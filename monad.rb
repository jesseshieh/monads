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

fail unless Maybe.from_value(1).bind do |value|
  Maybe.from_value(value + 1)
end.value == 2

fail unless Maybe.from_value(nil).bind do |value|
  Maybe.from_value(value + 1)
end.value == nil

fail unless Maybe.from_value(1).value == 1

class Many
  def initialize(values)
    @value = values
  end

  def self.from_value(value)
    Many.new([value])
  end

  attr_reader :value

  def bind(&block)
    Many.new(@value.map(&block).map(&:value).flatten)
  end
end

fail unless Many.new([1, 2, 3]).bind do |i|
  Many.new([i * 10, i * 100])
end.value == [10, 100, 20, 200, 30, 300]
fail unless Many.new([]).value == []

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

fail unless Either.from_value(1).value == 1
fail unless Either.from_value(-1).bind do |value|
  Either::Failure.new("Must be positive.")
end.value == "Must be positive."
fail unless Either.from_value(1).bind do |value|
  Either::Success.new(value + 1)
end.value == 2
fail unless Either.from_value(1).bind do |value|
  Either::Failure.new("Must be positive.")
end.bind do |value|
  Either::Success.new(value + 1)
end.value == "Must be positive."

class EventualComputation
  def initialize(&block)
    @block = block
  end

  def self.from_value(value)
    EventualComputation.new do
      value
    end
  end

  def bind(&block)
    EventualComputation.new do
      result = @block.call
      block.call(result).value
    end
  end

  def value
    @block.call
  end
end

fail unless EventualComputation.from_value(1).value == 1
fail unless EventualComputation.from_value(1).bind do |value|
  EventualComputation.new do
    value + 1
  end
end.value == 2
fail unless EventualComputation.from_value(1).bind do |value|
  EventualComputation.new do
    value + 1
  end
end.bind do |value|
  EventualComputation.new do
    value + 10
  end
end.value == 12

class StatefulComputation
  def initialize(&block)
    @block = block
  end

  def self.from_value(value)
    StatefulComputation.new do |state|
      [value, state]
    end
  end

  def run(initial_state)
    @block.call(initial_state)
  end

  def bind(&block)
    StatefulComputation.new do |state|
      _, new_state = run(state)
      block.call(new_state)
    end
  end
end

def push(value)
  ->(stack) {
    stack.push(value)
    [nil, stack]
  }
end

pop = ->(stack) {
  value = stack.pop
  [value, stack]
}

fail unless StatefulComputation.from_value(1).run([]) == [1, []]
fail unless StatefulComputation.new(&push(4)).bind(&pop).bind(&pop).bind(&push(5)).
  run([1, 2, 3]) == [nil, [1, 2, 5]]

class Log
  def initialize(value, log)
    @value = value
    @log = log
  end

  attr_reader :value
  attr_reader :log

  def bind(&block)
    new_value, new_log = block.call(@value)
    Log.new(new_value, @log + [new_log])
  end
end

fail unless Log.new(0, []).value == 0
fail unless Log.new(0, []).log == []
l = Log.new(9, []).bind do |value|
  [value + 1, "Add 1. "]
end.bind do |value|
  [value * 10, "Times 10. "]
end
fail unless l.value == 100
fail unless l.log.join == "Add 1. Times 10. "

add1 = ->(value) {
  value + 1
}

class Functor
  def initialize(value)
    @value = value
  end

  attr_reader :value

  def fmap(&block)
    Functor.new(block.call(@value))
  end
end

fail unless Functor.new(5).fmap(&add1).value == 6

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

fail unless ApplicativeFunctor.new(&add1).fmap(&add1).value(6) == 8
