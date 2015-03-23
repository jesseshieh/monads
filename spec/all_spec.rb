# TODO: break this up.
require 'applicative_functor'
require 'functor'
require 'monad'


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




