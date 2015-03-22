# TODO: break this up.
require 'applicative_functor'
require 'functor'
require 'monad'

fail unless Maybe.from_value(1).bind do |value|
  Maybe.from_value(value + 1)
end.value == 2

fail unless Maybe.from_value(nil).bind do |value|
  Maybe.from_value(value + 1)
end.value == nil

fail unless Maybe.from_value(1).value == 1


fail unless Many.new([1, 2, 3]).bind do |i|
  Many.new([i * 10, i * 100])
end.value == [10, 100, 20, 200, 30, 300]
fail unless Many.new([]).value == []


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


fail unless Eventually.from_value(1).value == 1
fail unless Eventually.from_value(1).bind do |value|
  Eventually.new do
    value + 1
  end
end.value == 2
fail unless Eventually.from_value(1).bind do |value|
  Eventually.new do
    value + 1
  end
end.bind do |value|
  Eventually.new do
    value + 10
  end
end.value == 12


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

fail unless State.from_value(1).run([]) == [1, []]
fail unless State.new(&push(4)).bind(&pop).bind(&pop).bind(&push(5)).
  run([1, 2, 3]) == [nil, [1, 2, 5]]


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


fail unless Functor.new(5).fmap(&add1).value == 6


fail unless ApplicativeFunctor.new(&add1).fmap(&add1).value(6) == 8
