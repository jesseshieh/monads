# TODO: break this up.
require 'applicative_functor'
require 'functor'
require 'monad'

fail unless Monad::Either.lift(1).value == 1
fail unless Monad::Either.lift(-1).bind do |value|
  Monad::Either::Failure.new("Must be positive.")
end.value == "Must be positive."
fail unless Monad::Either.lift(1).bind do |value|
  Monad::Either::Success.new(value + 1)
end.value == 2
fail unless Monad::Either.lift(1).bind do |value|
  Monad::Either::Failure.new("Must be positive.")
end.bind do |value|
  Monad::Either::Success.new(value + 1)
end.value == "Must be positive."


fail unless Monad::Eventually.lift(1).value == 1
fail unless Monad::Eventually.lift(1).bind do |value|
  Monad::Eventually.new do
    value + 1
  end
end.value == 2
fail unless Monad::Eventually.lift(1).bind do |value|
  Monad::Eventually.new do
    value + 1
  end
end.bind do |value|
  Monad::Eventually.new do
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

fail unless Monad::State.lift(1).run([]) == [1, []]
fail unless Monad::State.new(&push(4)).bind(&pop).bind(&pop).bind(&push(5)).
  run([1, 2, 3]) == [nil, [1, 2, 5]]


fail unless Monad::Log.new(0, []).value == 0
fail unless Monad::Log.new(0, []).log == []
l =Monad:: Log.new(9, []).bind do |value|
  [value + 1, "Add 1. "]
end.bind do |value|
  [value * 10, "Times 10. "]
end
fail unless l.value == 100
fail unless l.log.join == "Add 1. Times 10. "

add1 = ->(value) {
  value + 1
}

fail unless Monad::Identity.new(3).bind do |value|
  Monad::Identity.new(value * 2)
end.value == 6

fail unless Functor::Identity.new(5).fmap(&add1).value == 6


i = ApplicativeFunctor::Identity.new ->(value) {
  value + 1
}
j = ApplicativeFunctor::Identity.new ->(value) {
  value * 2
}
k = ApplicativeFunctor::Identity.new 3
fail unless i.apply(j).apply(k).value == 8

# ApplicativeFunctor is also a functor
a = ApplicativeFunctor::Identity.new 4
fail unless a.fmap(->(value) {
  value / 2
}).value == 2
